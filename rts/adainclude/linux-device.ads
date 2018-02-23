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

with System;
with Linux.Types;
with Linux.Module;
with Linux.Char_Device;

package Linux.Device is

   package LT renames Linux.Types;

   type Class_Type  is private;
   type Device_Type is private;

   NONE_DEVICE : constant Device_Type;

   function Class_Create
      (Owner : Linux.Module.Module_Type;
       Name   : String) return Class_Type;

   procedure Class_Destroy
      (Class : Class_Type);

   function Device_Create
      (Class        : Class_Type;
       Parent       : Device_Type;
       Devt         : Linux.Char_Device.Dev_Type;
       Driver_Data  : LT.Lazy_Pointer_Type;
       Name         : String)
   return Device_Type;

   procedure Device_Destroy
      (Class : Class_Type;
       Devt  : Linux.Char_Device.Dev_Type);

   pragma Import
     (Convention    => C,
      Entity        => Device_Destroy,
      External_Name => "device_destroy");

private

   type Class_Type  is new LT.Lazy_Pointer_Type;
   type Device_Type is new LT.Lazy_Pointer_Type;

   NONE_DEVICE : constant Device_Type := Device_Type (System.Null_Address);

end Linux.Device;
