------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                      L I N U X . C H A R  D E V I C E                    --
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
--
--  This package facilitates creation of character devices.
--

with Interfaces.C.Strings;

package body Linux.Char_Device is

--  We will use exception instead of checking return codes...

--  major = register_chrdev(0, DEVICE_NAME, &hr_fops);

--  hr_class = class_create(THIS_MODULE, DEVICE_NAME);

--  hr_device = device_create(hr_class,
--  NULL, MKDEV(major, 0), NULL, DEVICE_NAME);

   function Register return Major_Type is

      function register_chrdev (
         major : Interfaces.C.unsigned;
         name  : Interfaces.C.Strings.chars_ptr;
         fops  : Interfaces.C.Strings.chars_ptr) return Interfaces.C.unsigned;

      pragma Import
        (Convention    => C,
         Entity        => register_chrdev,
         External_Name => "register_chrdev");

   begin

      return 0;

   end Register;

--  device_destroy(hr_class, MKDEV(major, 0));
--  class_destroy(hr_class);
--  unregister_chrdev(major, DEVICE_NAME);

end Linux.Char_Device;
