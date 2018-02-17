------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                         L I N U X . D E V I C E                          --
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
-- This package follows some of the functions declared in linux/device.h
--

with Linux.Module;
with Linux.Types;

package Linux.Device is

   package LT renames Linux.Types;

   type Class_Type is private;

   function Class_Create (Owner : Linux.Module.Module_Type;
                          Name   : String) return Class_Type;

   procedure Class_Destroy (Class : Class_Type);

private

   type Class_Type is new LT.Lazy_Pointer_Type;

end Linux.Device;
