------------------------------------------------------------------------------
--                                                                          --
--                        GNAT RUN-TIME COMPONENTS                          --
--                                                                          --
--                           LAST CHNACE HANDLER                            --
--                                                                          --
--                                 B o d y                                  --
--                       (GNU-Linux/x86-64 Version)                         --
--                                                                          --
--          Copyright (C) 1992-2016, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
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

procedure Last_Chance_Handler
   (Source_Location : Interfaces.C.Strings.chars_ptr;
    Line            : Integer) is

   pragma Unreferenced (Line);

   procedure Printk_Wrapper (S     : Interfaces.C.Strings.chars_ptr;
                             Level : Integer);

   procedure Panic_Wrapper (S : Interfaces.C.Strings.chars_ptr);

   pragma Import
     (Convention    => C,
      Entity        => Printk_Wrapper,
      External_Name => "printk_wrapper");

   pragma Import
     (Convention    => C,
      Entity        => Panic_Wrapper,
      External_Name => "panic_wrapper");

begin

   --  Printk_Wrapper (
   --     "Entered Last_Chance_Handler due to unhandled exception", 3);
   Printk_Wrapper (Source_Location, 3);

   Panic_Wrapper (Source_Location);

end Last_Chance_Handler;
