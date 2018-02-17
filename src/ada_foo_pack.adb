--  with Ada.Characters.Latin_1;

with System;
with Linux.Types;
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

   DEVICE_NAME : constant String := "artiumdev";
   
   Major : Linux.Char_Device.Major_Type;

   Class : Linux.Device.Class_Type;

   File_Ops : Linux.Char_Device.File_Operations_Type :=
      (Owner  => Linux.Module.THIS_MODULE,
       others => LT.Lazy_Pointer_Type(System.Null_Address));

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

      --  major = register_chrdev(0, DEVICE_NAME, &hr_fops);
      --  hr_class = class_create(THIS_MODULE, DEVICE_NAME);
      --  hr_device = device_create(hr_class,
      --     NULL, MKDEV(major, 0), NULL, DEVICE_NAME);

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


      --  Currently not working:
      --  raise Constraint_Error;
      --  Linux.Kernel_IO.Put_Line ("Did this run after exception was raised?");
   end Ada_Foo;

   procedure Ada_Unfoo is
   begin

      --  device_destroy(hr_class, MKDEV(major, 0));
      --  class_destroy(hr_class);
      --  unregister_chrdev(major, DEVICE_NAME);
      Linux.Kernel_IO.Put_Line ("Will unregister device number" 
         & Linux.Char_Device.Major_Type'Image(Major));
      Linux.Char_Device.Unregister(Major, DEVICE_NAME);

      Linux.Device.Class_Destroy(Class);

   end;

begin
   null;
end Ada_Foo_Pack;
