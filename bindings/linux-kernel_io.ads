------------------------------------------------------------------------------
--                                                                          --
--                    LINUX MODULE DEVELOPMENT BINDINGS                     --
--                                                                          --
--                       L I N U X . K E R N E L _ I O                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2016, Artium Nihamkin artium@nihamkin.com         --
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

--  Note: the generic subpackages of Text_IO (Integer_IO, Fixed_IO,
--  Modular_IO, Decimal_IO and Enumeration_IO) appear as private children in
--  GNAT. These children are with'ed automatically if they are referenced, so
--  this rearrangement is invisible to user programs, but has the advantage
--  that only the needed parts of Text_IO are processed and loaded.

with System;

package Linux.Kernel_IO is
   pragma Elaborate_Body;

   type Kernel_Level_Type is
     (EMERGENCY,  -- system is unusable
      ALERT,      -- action must be taken immediately
      CRITICAL,   -- critical conditions
      ERROR,      -- error conditions
      WARNING,    -- warning conditions
      NOTICE,     -- normal but significant condition
      INFO,       -- informational
      DEBUG,      -- debug-level messages
      NONE        -- continue non terminated line or use default
     );

   --  procedure New_Line;
   ----------------------------
   -- Character Input-Output --
   ----------------------------
   --  procedure Put
   --  (Item : Character);

   -------------------------
   -- String Input-Output --
   -------------------------
   procedure Put
     (Item         : String;
      Kernel_Level : Kernel_Level_Type := NONE);

   procedure Put_Line
     (Item         : String;
      Kernel_Level : Kernel_Level_Type := NONE);

   ---------------------------------------
   -- Generic packages for Input-Output --
   ---------------------------------------

   --  The generic packages:

   --    Linux.Kernel_IO.Integer_IO
   --    Linux.Kernel_IO.Modular_IO
   --    Linux.Kernel_IO.Float_IO
   --    Linux.Kernel_IO.Fixed_IO
   --    Linux.Kernel_IO.Text_IO.Decimal_IO
   --    Linux.Kernel_IO.Text_IO.Enumeration_IO

   --  are implemented as separate child packages in GNAT, so the
   --  spec and body of these packages are to be found in separate
   --  child units. This implementation detail is hidden from the
   --  Ada programmer by special circuitry in the compiler that
   --  treats these child packages as though they were nested in
   --  Text_IO. The advantage of this special processing is that
   --  the subsidiary routines needed if these generics are used
   --  are not loaded when they are not used.

   ----------------
   -- Exceptions --
   ----------------

   --  Status_Error : exception renames IO_Exceptions.Status_Error;
   --  Mode_Error   : exception renames IO_Exceptions.Mode_Error;
   --  Name_Error   : exception renames IO_Exceptions.Name_Error;
   --  Use_Error    : exception renames IO_Exceptions.Use_Error;
   --  Device_Error : exception renames IO_Exceptions.Device_Error;
   --  End_Error    : exception renames IO_Exceptions.End_Error;
   --  Data_Error   : exception renames IO_Exceptions.Data_Error;
   --  Layout_Error : exception renames IO_Exceptions.Layout_Error;

end Linux.Kernel_IO;
