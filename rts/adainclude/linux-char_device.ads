------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                      L I N U X . C H A R  D E V I C E                    --
--                                                                          --
--                                 S p e c                                  --
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

with Interfaces.C;
with Linux.Types;
with Linux.Module;

package Linux.Char_Device is

   package LT renames Linux.Types;

   MAJOR_MAX : constant Interfaces.C.unsigned;
   pragma Import (
      Convention    => C,
      Entity        => MAJOR_MAX,
      External_Name => "major_max"
   );

   type Major_Type is new Integer range 0 .. Integer (MAJOR_MAX);

   --  Equivalent to struct file_operations
   --    /usr/src/linux-headers-4.9.0-4-common/include/linux/fs.h
   --
   type File_Operations_Type is record
      Owner                     : Linux.Module.Module_Type;
      Lock_Less_Seek            : LT.Lazy_Pointer_Type;
      Read                      : LT.Lazy_Pointer_Type;
      Write                     : LT.Lazy_Pointer_Type;
      Read_Iter                 : LT.Lazy_Pointer_Type;
      Write_Iter                : LT.Lazy_Pointer_Type;
      Iterate                   : LT.Lazy_Pointer_Type;
      Iterate_Shared            : LT.Lazy_Pointer_Type;
      Poll                      : LT.Lazy_Pointer_Type;
      Unlocked_IOCTL            : LT.Lazy_Pointer_Type;
      Compact_IOCTL             : LT.Lazy_Pointer_Type;
      Memory_Map                : LT.Lazy_Pointer_Type;
      Open                      : LT.Lazy_Pointer_Type;
      Flush                     : LT.Lazy_Pointer_Type;
      Release                   : LT.Lazy_Pointer_Type;
      F_Sync                    : LT.Lazy_Pointer_Type;
      F_Async_Sync              : LT.Lazy_Pointer_Type;
      Lock                      : LT.Lazy_Pointer_Type;
      Send_Page                 : LT.Lazy_Pointer_Type;
      Get_Unmapped_Area         : LT.Lazy_Pointer_Type;
      Check_Flags               : LT.Lazy_Pointer_Type;
      Set_FL                    : LT.Lazy_Pointer_Type;
      F_Lock                    : LT.Lazy_Pointer_Type;
      Splice_Write              : LT.Lazy_Pointer_Type;
      Splice_Read               : LT.Lazy_Pointer_Type;
      Set_Lease                 : LT.Lazy_Pointer_Type;
      F_Allocate                : LT.Lazy_Pointer_Type;
      Show_File_Descriptor_Info : LT.Lazy_Pointer_Type;

      --  #ifdef CONFIG_MMU
      Memory_Map_Capabilities   : LT.Lazy_Pointer_Type;

      Copy_File_Range           : LT.Lazy_Pointer_Type;
      Clone_File_Range          : LT.Lazy_Pointer_Type;
      Dedupe_File_Range         : LT.Lazy_Pointer_Type;
   end record;
   pragma Convention (C, File_Operations_Type);

   function Register (
      Major           : Major_Type;
      Name            : String;
      File_Operations : File_Operations_Type)
   return Major_Type;

   procedure Unregister (
      Major           : Major_Type;
      Name            : String);

end Linux.Char_Device;
