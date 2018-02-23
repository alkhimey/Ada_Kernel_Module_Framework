------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                     L I N U X . U S E R  S P A C E                       --
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

package body Linux.User_Space is

   procedure Copy_To_User (
      To   : User_Pointer;
      From : String;
      N    : LT.Size_Type)
   is

      use type Interfaces.C.unsigned_long;

      function copy_to_user_wrapper (
         To   : User_Pointer;
         From : Interfaces.C.char_array;
         N    : Interfaces.C.unsigned_long)
      return Interfaces.C.unsigned_long;

      pragma Import
         (Convention    => C,
          Entity        => copy_to_user_wrapper,
          External_Name => "copy_to_user_wrapper");

      Ret : Interfaces.C.unsigned_long;

   begin
      --  Interfaces.C.Strings.To_Chars_Ptr (Arr_Access),
      Ret := copy_to_user_wrapper (
         To   => To,
         From => Interfaces.C.To_C (From),
         N    => Interfaces.C.unsigned_long (N));

      --  TODO: Raise exception on Ret!
      if Ret /= 0 then
         raise Program_Error;
      end if;

   end Copy_To_User;

end Linux.User_Space;
