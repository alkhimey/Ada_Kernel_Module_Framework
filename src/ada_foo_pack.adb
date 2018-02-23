--  with Ada.Characters.Latin_1;

with System;
with Linux.Types;
with Linux.User_Space;
with Linux.Kernel_IO;
with Linux.Char_Device;
with Linux.Module;
with Linux.Device;

package body Ada_Foo_Pack is

   package LT renames Linux.Types;

   type Color_Type is (RED, BLACK, PURPLE_BLUE);
   type Fixed_Point_Type is delta 0.1 range -100.0 .. 100.0;
   type Unsigned_Type is mod 2**32;
   type Float_Type is digits 6;
   
   Major : Linux.Char_Device.Major_Type;

   Class  : Linux.Device.Class_Type;
   Device : Linux.Device.Device_Type;

   --  TODO:
   function Read_Example (
      File       : LT.Lazy_Pointer_Type;
      Out_Buffer : Linux.User_Space.User_Pointer;
      Size       : LT.Size_Type;
      P_Pos      : LT.Lazy_Pointer_Type)
   return LT.SSize_Type;

   File_Ops : Linux.Char_Device.File_Operations_Type :=
      (Owner  => Linux.Module.THIS_MODULE,
       Read   => Read_Example'access,
       others => LT.Lazy_Pointer_Type(System.Null_Address));

   function Read_Example (
      File       : LT.Lazy_Pointer_Type;
      Out_Buffer : Linux.User_Space.User_Pointer;
      Size       : LT.Size_Type;
      P_Pos      : LT.Lazy_Pointer_Type)
   return LT.SSize_Type is

      use type LT.Size_Type; 

      Message : String := "Lorem ipsum dolor sit amet";
      Size_To_Copy : LT.Size_Type;

   begin

      Size_To_Copy := LT.Size_Type'Min(Message'Size, Size);

      Linux.User_Space.Copy_To_User
         (To   => Out_Buffer,
          From => Message
                   (Message'First ..
                    Message'First + Integer(Size_To_Copy)),
          N    => Size);

      return LT.SSize_Type (Size_To_Copy);

   end Read_Example;


   procedure Ada_Foo is
      S1 : constant String := Integer'Image (42) & Character'Val (0);
      S2 : constant String :=
         Color_Type'Image (PURPLE_BLUE) & Character'Val (0);
      S3 : constant String := Boolean'Image (True)    & Character'Val (0);
      S4 : constant String := Fixed_Point_Type'Image (4.0) & Character'Val (0);
      S5 : constant String := Integer'Image (-42) & Character'Val (0);
      S6 : constant String := Unsigned_Type'Image (42) & Character'Val (0);
      S7 : constant String := Float_Type'Image (424.242) & Character'Val (0);

   begin
      Linux.Kernel_IO.Put_Line (S1);
      Linux.Kernel_IO.Put_Line (S2);
      Linux.Kernel_IO.Put_Line (S3);
      Linux.Kernel_IO.Put_Line (S4);
      Linux.Kernel_IO.Put_Line (S5);
      Linux.Kernel_IO.Put_Line (S6);
      Linux.Kernel_IO.Put_Line (S7);

      Linux.Kernel_IO.Put_Line ("C Bindings are working.");

      -- Registering a character device
      -- 
      Linux.Kernel_IO.Put_Line ("Registering character device number...");
      Major := Linux.Char_Device.Register(
         Major           => 0,
         Name            => "artiumchardev",
         File_Operations => File_Ops); 
   
      Linux.Kernel_IO.Put_Line ("Registered character device number" 
         & Linux.Char_Device.Major_Type'Image(Major));

      Linux.Kernel_IO.Put_Line ("Creating class...");
      Class := Linux.Device.Class_Create(
         Owner => Linux.Module.THIS_MODULE, 
         Name  => "artiumclass"); 
      Linux.Kernel_IO.Put_Line ("Created class, check /sys/class/classname");

      Linux.Kernel_IO.Put_Line ("Creating device...");
      Device := Linux.Device.Device_Create(
         Class       => Class,
         Parent      => Linux.Device.NONE_DEVICE,
         Devt        => Linux.Char_Device.Make_Dev(Major, 13),
         Driver_Data => LT.Lazy_Pointer_Type (System.Null_Address),
         Name        => "artiumdevice");
      Linux.Kernel_IO.Put_Line ("Created device, check /dev");


      --  Currently not working:
      --  raise Constraint_Error;
      --  Linux.Kernel_IO.Put_Line ("Did this run after exception was raised?");
   end Ada_Foo;

   procedure Ada_Unfoo is
   begin

      Linux.Kernel_IO.Put_Line ("Will destroy device");
      Linux.Device.Device_Destroy (
         Class => Class,
         Devt  => Linux.Char_Device.Make_Dev(Major, 13));

      Linux.Kernel_IO.Put_Line ("Will destroy class");
      Linux.Device.Class_Destroy (Class);

      Linux.Kernel_IO.Put_Line ("Will unregister device number" 
         & Linux.Char_Device.Major_Type'Image(Major));
      Linux.Char_Device.Unregister(Major, "artiumchardev");

   end;

begin
   null;
end Ada_Foo_Pack;
