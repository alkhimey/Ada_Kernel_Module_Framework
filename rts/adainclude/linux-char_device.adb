------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                      L I N U X . C H A R  D E V I C E                    --
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
--
--  This package facilitates creation of character devices.
--

with Interfaces.C.Strings;

package body Linux.Char_Device is

   --  type LLSeek_Access_Type is access function (
   --   File_Access : Linux.FS.File_Access_Type;
   --   Offset      : Long_Offset_Type;
   --   Whence      : Whence_Type) return Long_Offset_Type;

   function Register (
      Major           : Major_Type;
      Name            : String;
      File_Operations : File_Operations_Type)
   return Major_Type is

      use type Interfaces.C.unsigned;
      use type Interfaces.C.int;

      function register_chrdev (
         major : Interfaces.C.unsigned;
         name  : Interfaces.C.Strings.chars_ptr;
         fops  : File_Operations_Type) return Interfaces.C.int;

      pragma Import
        (Convention    => C,
         Entity        => register_chrdev,
         External_Name => "register_chrdev_wrapper");

      Name_Chars : Interfaces.C.Strings.chars_ptr :=
         Interfaces.C.Strings.New_String (Name);

      Ret_Val : Interfaces.C.int;

   begin
      --  http://www.linuxsavvy.com/resources/linux/man/man9/
      --           register_chrdev.9.html

      Ret_Val := register_chrdev (
         Interfaces.C.unsigned (Major),
         Name_Chars,
         File_Operations);
      Interfaces.C.Strings.Free (Name_Chars);

      --  TODO: -EINVAL, -EBUSY
      if Ret_Val < 0 then
         raise Program_Error;
      end if;

      return (if Major /= 0 then Major else Major_Type (Ret_Val));

   end Register;

   procedure Unregister (
      Major           : Major_Type;
      Name            : String)
   is

      procedure unregister_chrdev (
         major : Interfaces.C.unsigned;
         name  : Interfaces.C.Strings.chars_ptr);

      pragma Import
        (Convention    => C,
         Entity        => unregister_chrdev,
         External_Name => "unregister_chrdev_wrapper");

      Name_Chars : Interfaces.C.Strings.chars_ptr :=
         Interfaces.C.Strings.New_String (Name);

   begin

      unregister_chrdev (
         Interfaces.C.unsigned (Major),
         Name_Chars);

      Interfaces.C.Strings.Free (Name_Chars);

   end Unregister;

end Linux.Char_Device;
