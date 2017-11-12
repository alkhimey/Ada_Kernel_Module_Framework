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

--  CHAR_BIT

with Interfaces.C;

package Linux.Char_Device is

   MAJOR_MAX : constant Interfaces.C.unsigned;
   pragma Import (
      Convention    => C,
      Entity        => MAJOR_MAX,
      External_Name => "major_max"
   );

   type Major_Type is new Integer range 0 .. Integer (MAJOR_MAX);

   function Register return Major_Type;

end Linux.Char_Device;
