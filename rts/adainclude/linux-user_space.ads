------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                     L I N U X . U S E R  S P A C E                       --
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
--  Interacting with the user space.
--
with Interfaces.C;
with Interfaces.C.Strings;
with Linux.Types;

package Linux.User_Space is

   package LT renames Linux.Types;

   --  procedure Copy_From_User (
   --     To   : Interfaces.C.Strings.Char_Ptr;
   --     From : Interfaces.C.Strings.Char_Ptr;
   --     N    : Interfaces.C.unsigned_long)
   --  return Interfaces.C.unsigned_long;

   --  TODO: Find Ada way to prevent operations on these
   type User_Pointer is private;

   function Copy_To_User (
      To   : User_Pointer;
      From : String;
      N    : LT.Size_Type)
   return LT.Size_Type;

private

   type User_Pointer is new Interfaces.C.Strings.chars_ptr;

end Linux.User_Space;
