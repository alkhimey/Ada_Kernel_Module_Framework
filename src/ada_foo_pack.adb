--  with Ada.Characters.Latin_1;

with System;
with Interfaces.C.Strings;
with Linux.Types;
with Linux.Kernel_IO;
with Linux.Char_Device;

package body Ada_Foo_Pack is

   package LT renames Linux.Types;

   type Color_Type is (RED, BLACK, PURPLE_BLUE);
   type Fixed_Point_Type is delta 0.1 range -100.0 .. 100.0;
   type Unsigned_Type is mod 2**32;
   type Float_Type is digits 6;

   Custom_Exception : exception;

   DEVICE_NAME : constant String := "artiumdev";
   
   Major : Linux.Char_Device.Major_Type;

   procedure Panic_Wrapper (S : Interfaces.C.Strings.chars_ptr);
   pragma Import
     (Convention    => C,
      Entity        => Panic_Wrapper,
      External_Name => "panic_wrapper");

   procedure Oops_Wrapper;
   pragma Import
     (Convention    => C,
      Entity        => Oops_Wrapper,
      External_Name => "oops_wrapper");

   procedure Ada_Foo is
      S1 : constant String := Integer'Image (42) & Character'Val (0);
      S2 : constant String :=
         Color_Type'Image (PURPLE_BLUE) & Character'Val (0);
      S3 : constant String := Boolean'Image (True)    & Character'Val (0);
      S4 : constant String := Fixed_Point_Type'Image (4.0) & Character'Val (0);
      S5 : constant String := Integer'Image (-42) & Character'Val (0);
      S6 : constant String := Unsigned_Type'Image (42) & Character'Val (0);
      S7 : constant String := Float_Type'Image (424.242) & Character'Val (0);

      File_Ops : Linux.Char_Device.File_Operations_Type :=
         (others => LT.Lazy_Pointer_Type(System.Null_Address));

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

      --  major = register_chrdev(0, DEVICE_NAME, &hr_fops);
      --  hr_class = class_create(THIS_MODULE, DEVICE_NAME);
      --  hr_device = device_create(hr_class,
      --     NULL, MKDEV(major, 0), NULL, DEVICE_NAME);

      Major := Linux.Char_Device.Register(
         Major           => 0,
         Name            => DEVICE_NAME,
         File_Operations => File_Ops); 
   
      Linux.Kernel_IO.Put_Line ("Registered character device number" 
         & Linux.Char_Device.Major_Type'Image(Major));

      declare
      begin
         Linux.Kernel_IO.Put_Line("Raising an exception...");
         raise Custom_Exception;
         Linux.Kernel_IO.Put_Line("You sre not supposed to see this.", Linux.Kernel_IO.ERROR);
      exception
         when Program_Error => Linux.Kernel_IO.Put_Line("Caught an Program_Error!");
         when Custom_Exception => Linux.Kernel_IO.Put_Line("Caught an Custom_Exception!");
         when others => Linux.Kernel_IO.Put_Line("Caught other exception!");
      end;


      --  Test exception propagation
      --  
      --  declare
      --  begin
      --     Linux.Kernel_IO.Put_Line("The following call will raise an exception...");
      --     Major := Linux.Char_Device.Register(
      --        Major           => Major, --  Use already allocated Major number
      --        Name            => "anotherDevice",
      --        File_Operations => File_Ops); 
      --     Linux.Kernel_IO.Put_Line("You sre not supposed to see this.", Linux.Kernel_IO.ERROR);
      --  exception
      --     when others => Linux.Kernel_IO.Put_Line("Caught other exception!");
      --  end;
      --  Testing last chance handler
      --  Currently not working... 
      --  Linux.Kernel_IO.Put_Line("Before panic");
      --  oops_Wrapper;
      --  TODO: Leaky memory here
      --  Panic_Wrapper(Interfaces.C.Strings.New_String("Panic from Ada kernel module"));
      --  Linux.Kernel_IO.Put_Line("After panic");

      --  Currently not working:
      --  raise Constraint_Error;
      --  Linux.Kernel_IO.Put_Line("You sre not supposed to see this.", Linux.Kernel_IO.ERROR);
   end Ada_Foo;

   procedure Ada_Unfoo is
   begin

      --  device_destroy(hr_class, MKDEV(major, 0));
      --  class_destroy(hr_class);
      --  unregister_chrdev(major, DEVICE_NAME);
      Linux.Kernel_IO.Put_Line ("Will unregister device number" 
         & Linux.Char_Device.Major_Type'Image(Major));
      Linux.Char_Device.Unregister(Major, DEVICE_NAME);

   end;

begin
   null;
end Ada_Foo_Pack;
