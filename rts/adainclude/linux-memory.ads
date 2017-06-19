------------------------------------------------------------------------------
--                                                                          --
--                          LINUX KERNEL BINDINGS                           --
--                                                                          --
--                         L I N U X . M E M O R Y                          --
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
--  This package provides the low level interface to the C linux kernel
--  memory allocation and releasing functions.
--  Based on /usr/src/linux-headers-4.4.0-79/include/linux/gfp.h
--

with System;
with System.CRTL;

package Linux.Memory is

   type size_t is mod 2 ** Standard'Address_Size;
   --  Note: the reason we redefine this here instead of using the
   --  definition in Interfaces.C is that we do not want to drag in
   --  all of Interfaces.C just because System.Memory is used.

   type GFP_Flags_Index_Type is
      (GFP_DMA_BIT,            GFP_HIGHMEM_BIT,
       GFP_DMA32_BIT,          GFP_MOVABLE_BIT,
       GFP_RECLAIMABLE_BIT,    GFP_HIGH_BIT,
       GFP_IO_BIT,             GFP_FS_BIT,
       GFP_COLD_BIT,           GFP_NOWARN_BIT,
       GFP_REPEAT_BIT,         GFP_NOFAIL_BIT,
       GFP_NORETRY_BIT,        GFP_MEMALLOC_BIT,
       GFP_COMP_BIT,           GFP_ZERO_BIT,
       GFP_NOMEMALLOC_BIT,     GFP_HARDWALL_BIT,
       GFP_THISNODE_BIT,       GFP_ATOMIC_BIT,
       GFP_ACCOUNT_BIT,        GFP_NOTRACK_BIT,
       GFP_DIRECT_RECLAIM_BIT, GFP_WRITE_BIT,
       GFP_KSWAPD_RECLAIM_BIT, GFP_SPARE_26_BIT,
       GFP_SPARE_27_BIT,       GFP_SPARE_28_BIT,
       GFP_SPARE_29_BIT,       GFP_SPARE_30_BIT,
       GFP_SPARE_31_BIT,       GFP_SPARE_32_BIT);

   type GFP_Flag_Type is array (GFP_Flags_Index_Type) of Boolean;
   pragma Pack (GFP_Flag_Type);

   --  GFP_ATOMIC users can not sleep and need the allocation to succeed.
   --    A lower watermark is applied to allow access to "atomic reserves"
   --
   GFP_ATOMIC : constant GFP_Flag_Type :=
      (GFP_HIGH_BIT           => True,
       GFP_ATOMIC_BIT         => True,
       GFP_KSWAPD_RECLAIM_BIT => True,
       others                 => False);

   --  GFP_KERNEL is typical for kernel-internal allocations. The caller
   --    requires ZONE_NORMAL or a lower zone for direct access but can
   --    direct reclaim.
   --
   GFP_KERNEL : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             => True,
       others                 => False);

   --  GFP_NOWAIT is for kernel allocations that should not stall for direct
   --    reclaim, start physical IO or use any filesystem callback.
   --
   GFP_NOWAIT : constant GFP_Flag_Type :=
      (GFP_KSWAPD_RECLAIM_BIT => True,
       others                 => False);

   --  GFP_NOIO will use direct reclaim to discard clean pages or slab pages
   --    that do not require the starting of any physical IO.
   --
   GFP_NOIO : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT => True,
       others                 => False);

   --  GFP_NOFS will use direct reclaim but will not use any filesystem
   --    interfaces.
   --
   GFP_NOFS : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             => True,
       others                 => False);

   --  GFP_TEMPORARY
   --     See https://lwn.net/Articles/713076/
   --
   GFP_TEMPORARY : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             |
       GFP_RECLAIMABLE_BIT    => True,
       others                 => False);

   --  GFP_USER is for userspace allocations that also need to be directly
   --    accessibly by the kernel or hardware. It is typically used by hardware
   --    for buffers that are mapped to userspace (e.g. graphics) that hardware
   --    still must DMA to. cpuset limits are enforced for these allocations.
   --
   GFP_USER : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             |
       GFP_HARDWALL_BIT       => True,
       others                 => False);

   --  GFP_DMA exists for historical reasons and should be avoided where
   --    possible. The flags indicates that the caller requires that the lowest
   --    zone be used (ZONE_DMA or 16M on x86-64). Ideally, this would be
   --    removed but it would require careful auditing as some users really
   --    require it and others use the flag to avoid lowmem reserves in
   --    ZONE_DMA and treat the lowest zone as a type of emergency reserve.
   --
   GFP_DMA : constant GFP_Flag_Type :=
      (GFP_DMA_BIT            => True,
       others                 => False);

   --  GFP_DMA32 is similar to GFP_DMA except that the caller requires a 32-bit
   --     address.
   --
   GFP_DMA32 : constant GFP_Flag_Type :=
      (GFP_DMA32_BIT          => True,
       others                 => False);

   --  GFP_HIGHUSER is for userspace allocations that may be mapped to
   --    userspace, do not need to be directly accessible by the kernel but
   --    that cannot move once in use. An example may be a hardware allocation
   --    that maps data directly into userspace but has no addressing
   --    limitations.
   --
   GFP_HIGHUSER : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             |
       GFP_HARDWALL_BIT       |
       GFP_HIGHMEM_BIT        => True,
       others                 => False);

   --  GFP_HIGHUSER_MOVABLE is for userspace allocations that the kernel does
   --    not need direct access to but can use kmap() when access is required.
   --    They are expected to be movable via page reclaim or page migration.
   --    Typically, pages on the LRU would also be allocated with
   --    GFP_HIGHUSER_MOVABLE.
   --
   GFP_HIGHUSER_MOVABLE : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_KSWAPD_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             |
       GFP_HARDWALL_BIT       |
       GFP_HIGHMEM_BIT        |
       GFP_MOVABLE_BIT        => True,
       others                 => False);

   --  GFP_TRANSHUGE is used for THP allocations. They are compound allocations
   --    that will fail quickly if memory is not available and will not wake
   --    kswapd on failure.
   --
   GFP_TRANSHUGE : constant GFP_Flag_Type :=
      (GFP_DIRECT_RECLAIM_BIT |
       GFP_IO_BIT             |
       GFP_FS_BIT             |
       GFP_HARDWALL_BIT       |
       GFP_HIGHMEM_BIT        |
       GFP_MOVABLE_BIT        |
       GFP_COMP_BIT           |
       GFP_NOMEMALLOC_BIT     |
       GFP_NORETRY_BIT        |
       GFP_NOWARN_BIT         => True,
       others                 => False);

   function kmalloc (Size     : System.CRTL.size_t;
                     GFP_Flag : GFP_Flag_Type) return System.Address;

   --  It is also possible to import __kmalloc but that is internal detail
   --  and less safer.
   --
   pragma Import (C, kmalloc, "kmalloc_wrapper");

   procedure kfree (Ptr : System.Address);
   pragma Import (C, kfree, "kfree");

end Linux.Memory;
