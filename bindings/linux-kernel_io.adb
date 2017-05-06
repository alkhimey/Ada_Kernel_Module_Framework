------------------------------------------------------------------------------
--                                                                          --
--                    LINUX MODULE DEVELOPMENT BINDINGS                     --
--                                                                          --
--                       L I N U X . K E R N E L _ I O                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2016, Free Software Foundation, Inc.         --
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
   
   -- TODO: ASCII start of header?
   KERNEL_LEVEL_CHAR : constant array (Kernel_Level_Type) of Character :=
     (EMERGENCY => '0',
      ALERT     => '1',
      CRITICAL  => '2',
      ERROR     => '3',
      WARNING   => '4',
      NOTICE    => '5',
      INFO      => '6',
      DEBUG     => '7',
      NONE      => '?'
     );
   
   procedure Print_Kernel_Chars (S : Interfaces.C.Strings.chars_ptr);
   
   pragma Import
     (Convention    => C,
      Entity        => Print_Kernel_Chars,
      External_Name => "print_kernel_chars");

   --  procedure New_Line 
   --  begin
   --    Put (ASCII.LF);
   --  end New_Line;

   --  procedure Put 
   --    (Item : Character) 
   --  is
   --     Str : String(1..1);
   --     Chars : Interfaces.C.Strings.Chars_Ptr; 
   --  begin
   --     Str(1) := Item;
   --     Chars  := New_String(Str);
   --     Print_Kernel_Chars(S);
   --  end;

   procedure Put 
     (Item         : String;
      Kernel_Level : Kernel_Level_Type := NONE) 
   is
      Chars : Interfaces.C.Strings.Chars_Ptr := Interfaces.C.Strings.New_String (Item);
   begin
      Print_Kernel_Chars (Chars);
      Interfaces.C.Strings.Free (Chars);
   end;

   

   procedure Put_Line
     (Item         : String;
      Kernel_Level : Kernel_Level_Type := NONE) 
   is
      Chars : Interfaces.C.Strings.Chars_Ptr := Interfaces.C.Strings.New_String (Item & ASCII.LF);
   begin
      Print_Kernel_Chars (Chars);
      Interfaces.C.Strings.Free (Chars);
   end Put_Line;
   
begin
   null;
end Linux.Kernel_IO;
