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
with Linux.User_Space;
with Linux.Module;

package Linux.Char_Device is

   package LT renames Linux.Types;

   --  use type Interfaces.C.unsigned;

   --  MINOR_BITS : constant Interfaces.C.unsigned;
   --  pragma Import (
   --     Convention    => C,
   --     Entity        => MINOR_BITS,
   --     External_Name => "minor_bits"
   --  );
   --
   --  MAJOR_MAX : constant Interfaces.C.unsigned;
   --  pragma Import (
   --     Convention    => C,
   --     Entity        => MAJOR_MAX,
   --     External_Name => "major_max"
   --  );
   --
   --  MINOR_MAX : constant Interfaces.C.unsigned;
   --  pragma Import (
   --     Convention    => C,
   --     Entity        => MINOR_MAX,
   --     External_Name => "minor_max"
   --  );

   type Major_Type is new Interfaces.C.unsigned;
   --  range 0 .. Integer (MAJOR_MAX);
   type Minor_Type is new Interfaces.C.unsigned;
   --  range 0 .. Integer (MINOR_MAX);
   type Dev_Type   is new Interfaces.C.unsigned;

   function Make_Dev
      (Major : Major_Type;
       Minor : Minor_Type) return Dev_Type;

   pragma Import
      (Convention    => C,
       Entity        => Make_Dev,
       External_Name => "mkdev_wrapper");

   --  type Dev_Type is
   --     record
   --        Minor : Minor_Type;
   --        Major : Major_Type;
   --  end record;
   --
   --  for Dev_Type use
   --     record
   --        Minor at 0 range 0              .. MINOR_BITS;
   --        Major at 0 range MINOR_BITS + 1 .. Interfaces.C.unsigned'Size;
   --  end record;

   --  ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);

   type Read_Access_Type is access function (
      File       : LT.Lazy_Pointer_Type;
      Out_Buffer : Linux.User_Space.User_Pointer;
      Size       : LT.Size_Type;
      P_Pos      : LT.Lazy_Pointer_Type)
   return LT.SSize_Type;

   --  Equivalent to struct file_operations
   --    /usr/src/linux-headers-4.9.0-4-common/include/linux/fs.h
   --
   type File_Operations_Type is record
      Owner                     : Linux.Module.Module_Type;
      Lock_Less_Seek            : LT.Lazy_Pointer_Type;
      Read                      : Read_Access_Type;
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
