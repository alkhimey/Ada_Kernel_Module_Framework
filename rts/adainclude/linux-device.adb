------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                         L I N U X . D E V I C E                          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 2017, Artium Nihamkin, artium@nihamkin.com        --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces.C.Strings;

package body Linux.Device is

   function Class_Create (Owner : Linux.Module.Module_Type;
                          Name  : String) return Class_Type is

      function class_create_wrapper (
         owner : Linux.Module.Module_Type;
         name  : Interfaces.C.Strings.chars_ptr) return Class_Type;

      pragma Import
        (Convention    => C,
         Entity        => class_create_wrapper,
         External_Name => "class_create_wrapper");

      Name_Chars : Interfaces.C.Strings.chars_ptr :=
         Interfaces.C.Strings.New_String (Name);

      Ret_Class : Class_Type;

   begin

      Ret_Class := class_create_wrapper (Owner, Name_Chars);
      Interfaces.C.Strings.Free (Name_Chars);

      --  TODO: Deal with errors (ERR_PTR(retval))
      return Ret_Class;

   end Class_Create;

   procedure Class_Destroy (Class : Class_Type) is

      procedure class_destroy (class : Class_Type);

      pragma Import
        (Convention    => C,
         Entity        => class_destroy,
         External_Name => "class_destroy");

   begin

      class_destroy (Class);

   end Class_Destroy;

   function Device_Create
      (Class       : Class_Type;
       Parent      : Device_Type;
       Devt        : Linux.Char_Device.Dev_Type;
       Driver_Data : LT.Lazy_Pointer_Type;
       Name        : String)
   return Device_Type is

      function device_create_inner (
         class   : Class_Type;
         parent  : Device_Type;
         devt    : Linux.Char_Device.Dev_Type;
         --  https://stackoverflow.com/questions/24408031/
         --      device-create-argument-void-drvdata
         drvdata : LT.Lazy_Pointer_Type;
         name    : Interfaces.C.Strings.chars_ptr)
      return Device_Type;

      pragma Import
        (Convention    => C,
         Entity        => device_create_inner,
         External_Name => "device_create");

      Name_Chars : Interfaces.C.Strings.chars_ptr :=
         Interfaces.C.Strings.New_String (Name);
      Ret_Device : Device_Type;
   begin
      Ret_Device := device_create_inner (
        class   => Class,
        parent  => Parent,
        devt    => Devt,
        drvdata => Driver_Data,
        name    => Name_Chars);

      Interfaces.C.Strings.Free (Name_Chars);

      --  TODO: Deal with errors (ERR_PTR(retval))
      return Ret_Device;

   end Device_Create;

end Linux.Device;
