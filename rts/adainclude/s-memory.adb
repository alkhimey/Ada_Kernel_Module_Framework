------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                         S Y S T E M . M E M O R Y                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 2001-2016, Free Software Foundation, Inc.         --
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

--  This is the default implementation of this package

--  This implementation assumes that the underlying malloc/free/realloc
--  implementation is thread safe, and thus, no additional lock is required.
--  Note that we still need to defer abort because on most systems, an
--  asynchronous signal (as used for implementing asynchronous abort of
--  task) cannot safely be handled while malloc is executing.

--  If you are not using Ada constructs containing the "abort" keyword, then
--  you can remove the calls to Abort_Defer.all and Abort_Undefer.all from
--  this unit.

pragma Compiler_Unit_Warning;

with System.CRTL;
with System.Parameters;
with System.Soft_Links;
with Linux.Memory;

package body System.Memory is

   use System.Soft_Links;

   function c_realloc
     (Ptr : System.Address; Size : System.CRTL.size_t) return System.Address;

   function c_malloc (Size  : System.CRTL.size_t;
                      Flags : Linux.Memory.GFP_Flag_Type)
    return System.Address
    renames Linux.Memory.kmalloc;

   procedure c_free (Ptr : System.Address)
     renames Linux.Memory.kfree;

   function c_realloc
     (Ptr : System.Address; Size : System.CRTL.size_t) return System.Address is
   begin
      raise Program_Error; -- Not implemented yet
      return System.Null_Address;
   end c_realloc;
   --  renames System.CRTL.realloc;

   -----------
   -- Alloc --
   -----------

   function Alloc (Size : size_t) return System.Address is
      Result : System.Address;
   begin
      --  A previous version moved the check for size_t'Last below, into the
      --  "if Result = System.Null_Address...". So malloc(size_t'Last) should
      --  return Null_Address, and then we can check for that special value.
      --  However, that doesn't work on VxWorks, because malloc(size_t'Last)
      --  prints an unwanted warning message before returning Null_Address.

      if Size = size_t'Last then
         raise Storage_Error with "object too large";
      end if;

      Result := c_malloc (System.CRTL.size_t (Size), Linux.Memory.GFP_KERNEL);

      if Result = System.Null_Address then

         --  If Size = 0, we can't allocate 0 bytes, because then two different
         --  allocators, one of which has Size = 0, could return pointers that
         --  compare equal, which is wrong. (Nonnull pointers compare equal if
         --  and only if they designate the same object, and two different
         --  allocators allocate two different objects).

         --  malloc(0) is defined to allocate a non-zero-sized object (in which
         --  case we won't get here, and all is well) or NULL, in which case we
         --  get here. We also get here in case of error. So check for the
         --  zero-size case, and allocate 1 byte. Otherwise, raise
         --  Storage_Error.

         --  We check for zero size here, rather than at the start, for
         --  efficiency.

         if Size = 0 then

            --  Unrolled recursion of "return Alloc (1);"
            --
            Result := c_malloc (System.CRTL.size_t (1),
                                Linux.Memory.GFP_KERNEL);

            if Result = System.Null_Address then
               raise Storage_Error with "heap exhausted";
            end if;

            return Result;

         end if;

         raise Storage_Error with "heap exhausted";
      end if;

      return Result;
   end Alloc;

   ----------
   -- Free --
   ----------

   procedure Free (Ptr : System.Address) is
   begin
      c_free (Ptr);
   end Free;

   -------------
   -- Realloc --
   -------------

   function Realloc
     (Ptr  : System.Address;
      Size : size_t)
      return System.Address
   is
      Result      : System.Address;
   begin
      if Size = size_t'Last then
         raise Storage_Error with "object too large";
      end if;

      Result := c_realloc (Ptr, System.CRTL.size_t (Size));

      if Result = System.Null_Address then
         raise Storage_Error with "heap exhausted";
      end if;

      return Result;
   end Realloc;

end System.Memory;
