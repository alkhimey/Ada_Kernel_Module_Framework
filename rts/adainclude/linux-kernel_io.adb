------------------------------------------------------------------------------
--                                                                          --
--                    LINUX MODULE DEVELOPMENT BINDINGS                     --
--                                                                          --
--                       L I N U X . K E R N E L _ I O                      --
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
with Interfaces.C;
with Interfaces.C.Strings;

package body Linux.Kernel_IO is

   procedure Printk_Wrapper (S     : Interfaces.C.Strings.chars_ptr;
                            Level : Printk_Level_Type);

   pragma Import
     (Convention    => C,
      Entity        => Printk_Wrapper,
      External_Name => "printk_wrapper");

   procedure Put_Line
     (Item         : String;
      Kernel_Level : Printk_Level_Type := DEFAULT)
   is
      Chars : Interfaces.C.Strings.chars_ptr :=
         Interfaces.C.Strings.New_String (Item);
   begin
      Printk_Wrapper (Chars, Kernel_Level);
      Interfaces.C.Strings.Free (Chars);
   end Put_Line;

begin
   null;
end Linux.Kernel_IO;
