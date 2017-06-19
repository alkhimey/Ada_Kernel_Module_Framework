------------------------------------------------------------------------------
--                                                                          --
--                    LINUX MODULE DEVELOPMENT BINDINGS                     --
--                                                                          --
--                       L I N U X . K E R N E L _ I O                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2017, Artium Nihamkin, artium@nihamkin.com        --
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

--  This package provides kernel printing facilities. It's structure is based
--  on the Text_IO standard library package.

--  with System;

package Linux.Kernel_IO is
   pragma Elaborate_Body;

   type Printk_Level_Type is
      (DEFAULT,
       EMERGENCY, -- system is unusable
       ALERT,     -- action must be taken immediately
       CRITICAL,  -- critical conditions
       ERROR,     -- error conditions
       WARNING,   -- warning conditions
       NOTICE,    -- normal but significant condition
       INFO,      -- informational
       DEBUG      -- debug-level messages
      );

   for Printk_Level_Type use
      (DEFAULT  => 0, EMERGENCY => 1, ALERT   => 2,
       CRITICAL => 3, ERROR     => 4, WARNING => 5,
       NOTICE   => 6, INFO      => 7, DEBUG   => 8
      );

   pragma Convention (C, Printk_Level_Type);

   -------------------------
   -- String Input-Output --
   -------------------------

   --  Notice that there is not Put function. It is explained
   --  in kern_levels.h why it is not supported: "a continued
   --  line is not SMP-safe".

   procedure Put_Line
     (Item         : String;
      Kernel_Level : Printk_Level_Type := DEFAULT);

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
