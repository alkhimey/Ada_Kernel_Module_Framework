------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2016, Free Software Foundation, Inc.         --
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

pragma Compiler_Unit_Warning;

--  with System.Parameters;

with Ada.Unchecked_Conversion;

package body System.Secondary_Stack is

   --  use type System.Parameters.Size_Type;
   use type SSE.Storage_Offset;

   --  TODO: Use this
   --  SS_Ratio_Dynamic : constant Boolean :=
   --     Parameters.Sec_Stack_Percentage = Parameters.Dynamic;

   --  There are two entirely different implementations of the secondary
   --  stack mechanism in this unit, and this Boolean is used to select
   --  between them (at compile time, so the generated code will contain
   --  only the code for the desired variant). If SS_Ratio_Dynamic is
   --  True, then the secondary stack is dynamically allocated from the
   --  heap in a linked list of chunks. If SS_Ration_Dynamic is False,
   --  then the secondary stack is allocated statically by grabbing a
   --  section of the primary stack and using it for this purpose.

   type Memory is array (SS_Ptr range <>) of SSE.Storage_Element;
   for Memory'Alignment use Standard'Maximum_Alignment;
   --  This is the type used for actual allocation of secondary stack
   --  areas. We require maximum alignment for all such allocations.

   --------------------------------------------------------------
   -- Data Structures for Statically Allocated Secondary Stack --
   --------------------------------------------------------------

   --  For the static case, the secondary stack is a single contiguous
   --  chunk of storage, carved out of the primary stack, and represented
   --  by the following data structure

   type Fixed_Stack_Id is record
      Top : SS_Ptr;
      --  Index of next available location in Mem. This is initialized to
      --  0, and then incremented on Allocate, and Decremented on Release.

      Last : SS_Ptr;
      --  Length of usable Mem array, which is thus the index past the
      --  last available location in Mem. Mem (Last-1) can be used. This
      --  is used to check that the stack does not overflow.

      Max : SS_Ptr;
      --  Maximum value of Top. Initialized to 0, and then may be incremented
      --  on Allocate, but is never Decremented. The last used location will
      --  be Mem (Max - 1), so Max is the maximum count of used stack space.

      Mem : Memory (0 .. 0);
      --  This is the area that is actually used for the secondary stack.
      --  Note that the upper bound is a dummy value properly defined by
      --  the value of Last. We never actually allocate objects of type
      --  Fixed_Stack_Id, so the bounds declared here do not matter.
   end record;

   Dummy_Fixed_Stack : Fixed_Stack_Id :=
     (Top  => 0,
      Last => 0,
      Max  => 0,
      Mem => (others => 0));
   pragma Warnings (Off, Dummy_Fixed_Stack);
   --  Well it is not quite true that we never allocate an object of the
   --  type. This dummy object is allocated for the purpose of getting the
   --  offset of the Mem field via the 'Position attribute (such a nuisance
   --  that we cannot apply this to a field of a type).

   type Fixed_Stack_Ptr is access Fixed_Stack_Id;
   --  Pointer to record used to describe statically allocated sec stack

   function To_Fixed_Stack_Ptr is new
     Ada.Unchecked_Conversion (Address, Fixed_Stack_Ptr);
   --  Convert from address stored in task data structures

   --------------
   -- Allocate --
   --------------

   procedure SS_Allocate
     (Addr         : in out Address;
      Storage_Size : SSE.Storage_Count)
   is
      Max_Align : constant SS_Ptr := SS_Ptr (Standard'Maximum_Alignment);
      Max_Size  : constant SS_Ptr :=
                    ((SS_Ptr (Storage_Size) + Max_Align - 1) / Max_Align) *
                      Max_Align;

      Fixed_Stack : constant Fixed_Stack_Ptr :=
                      To_Fixed_Stack_Ptr (Get_Sec_Stack_Addr);
   begin

      --  Check if max stack usage is increasing

      if Fixed_Stack.Top + Max_Size > Fixed_Stack.Max then

         --  If so, check if max size is exceeded

         if Fixed_Stack.Top + Max_Size > Fixed_Stack.Last then
            raise Storage_Error;
         end if;

         --  Record new max usage

         Fixed_Stack.Max := Fixed_Stack.Top + Max_Size;
      end if;

      --  Set resulting address and update top of stack pointer

      Addr := Fixed_Stack.Mem (Fixed_Stack.Top)'Address;
      Fixed_Stack.Top := Fixed_Stack.Top + Max_Size;

   end SS_Allocate;

   ----------------
   -- SS_Get_Max --
   ----------------

   function SS_Get_Max return Long_Long_Integer is
      Fixed_Stack : constant Fixed_Stack_Ptr :=
                   To_Fixed_Stack_Ptr (Get_Sec_Stack_Addr);
   begin

      return Long_Long_Integer (Fixed_Stack.Max);

   end SS_Get_Max;

   -------------
   -- SS_Info --
   -------------

   --  procedure SS_Info is
   --  begin
   --     Put_Line ("Secondary Stack information:");
   --
   --        declare
   --           Fixed_Stack : constant Fixed_Stack_Ptr :=
   --              To_Fixed_Stack_Ptr (SSL.Get_Sec_Stack_Addr.all);
   --
   --        begin
   --           Put_Line (
   --                     "  Total size              : "
   --                     & SS_Ptr'Image (Fixed_Stack.Last)
   --                     & " bytes");
   --
   --           Put_Line (
   --                     "  Current allocated space : "
   --                     & SS_Ptr'Image (Fixed_Stack.Top - 1)
   --                     & " bytes");
   --        end;
   --
   --  end SS_Info;

   -------------
   -- SS_Init --
   -------------

   procedure SS_Init
     (Stk  : in out Address;
      Size : Natural := Default_Secondary_Stack_Size)
   is

      Fixed_Stack : constant Fixed_Stack_Ptr :=
         To_Fixed_Stack_Ptr (Stk);

   begin

      Fixed_Stack.Top  := 0;
      Fixed_Stack.Max  := 0;

      if Size < Dummy_Fixed_Stack.Mem'Position then
         Fixed_Stack.Last := 0;
      else
         Fixed_Stack.Last :=
         SS_Ptr (Size) - Dummy_Fixed_Stack.Mem'Position;
      end if;

   end SS_Init;

   -------------
   -- SS_Mark --
   -------------

   function SS_Mark return Mark_Id is
      Sstk : constant System.Address := Get_Sec_Stack_Addr;
   begin

      return (Sstk => Sstk, Sptr => To_Fixed_Stack_Ptr (Sstk).Top);

   end SS_Mark;

   ----------------
   -- SS_Release --
   ----------------

   procedure SS_Release (M : Mark_Id) is
   begin

      To_Fixed_Stack_Ptr (M.Sstk).Top := M.Sptr;

   end SS_Release;

   -------------------------
   -- Package Elaboration --
   -------------------------

   --  Allocate a secondary stack for the main program to use

   Static_Secondary_Stack_Size : constant := 10 * 1024;
   --  Static_Secondary_Stack_Size must be static so that Chunk is allocated
   --  statically, and not via dynamic memory allocation.

   Chunk : aliased Memory (1 .. Static_Secondary_Stack_Size) := (others => 0);
   for Chunk'Alignment use Standard'Maximum_Alignment;
   --  Default chunk used, unless gnatbind -D is specified with a value greater
   --  than Static_Secondary_Stack_Size.

   -------------------------
   --  Get_Sec_Stack_Addr --
   -------------------------
   function Get_Sec_Stack_Addr return Address is
   begin
      return Chunk'Address;
   end Get_Sec_Stack_Addr;

begin
   declare
      Addr : Address := Get_Sec_Stack_Addr;
   begin

      if Default_Secondary_Stack_Size <= Static_Secondary_Stack_Size then

         --  Normally we allocate the secondary stack for the main program
         --  statically, using the default secondary stack size.

         SS_Init (Addr, Default_Secondary_Stack_Size);
      else

         raise Storage_Error; -- Not supported yet

         --  Default_Secondary_Stack_Size was increased via gnatbind -D, so we
         --  need to allocate a chunk dynamically.

         --  Chunk_Access :=
         --    new Chunk_Id (1, SS_Ptr (Default_Secondary_Stack_Size));
      end if;
   end;
end System.Secondary_Stack;
