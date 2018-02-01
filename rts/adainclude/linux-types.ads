------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                          L I N U X . T Y P E S                           --
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
--  This package contains common types used thoughout the kernel bindings.
--  These types should be platform independent.
--  It is allowed to rename this package as "LT".
--
--  Important: Some of the types here are defined with implicit assumption
--             that Ada types correspond to appropriate C types.
--             For example "Long_Long_Integer" is equivalent to "long long".
--             This is correct when compiling with GCC/Gnat and might not be
--             true for other compilers.
--

with System;

package Linux.Types is

   --  Types that are specific to this bindings
   ---------------------------------------------

   --  Use this when you are too lazy to define a type
   --
   type Lazy_Pointer_Type is new System.Address;

   --  Types parallel to "linux/types.h"
   -------------------------------------

   type Long_Offset_Type is new Long_Long_Integer;

   type u8  is mod 2**8;
   type u16 is mod 2**16;
   type u32 is mod 2**32;
   type u64 is mod 2**64;

end Linux.Types;
