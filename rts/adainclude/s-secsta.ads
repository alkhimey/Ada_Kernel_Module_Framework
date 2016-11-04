------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2013, Free Software Foundation, Inc.         --
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

with System.Storage_Elements;

package System.Secondary_Stack is

   package SSE renames System.Storage_Elements;

   Default_Secondary_Stack_Size : Natural := 10 * 1024;
   --  Default size of a secondary stack. May be modified by binder -D switch
   --  which causes the binder to generate an appropriate assignment in the
   --  binder generated file.

   procedure SS_Init
    (Stk  : in out Address;
     Size : Natural := Default_Secondary_Stack_Size);
   --  Initialize the secondary stack with a main stack of the given Size.
   --
   --  Note: the reason that Stk is passed is that SS_Init is called before
   --  the proper interface is established to obtain the address of the
   --  stack using System.Soft_Links.Get_Sec_Stack_Addr.

   procedure SS_Allocate
     (Addr         : in out Address;
      Storage_Size : SSE.Storage_Count);
   --  Allocate enough space for a 'Storage_Size' bytes object with Maximum
   --  alignment. The address of the allocated space is returned in Addr.

   procedure SS_Free (Stk : in out Address) is null;
   --  Null procedure in this runtime as the stack if fixed.

   type Mark_Id is private;
   --  Type used to mark the stack for mark/release processing

   function SS_Mark return Mark_Id;
   --  Return the Mark corresponding to the current state of the stack

   procedure SS_Release (M : Mark_Id);
   --  Restore the state of the stack corresponding to the mark M.

   function SS_Get_Max return Long_Long_Integer;
   --  Return maximum used space in storage units for the current secondary
   --  stack. For a statically allocated secondary stack, the returned value
   --  shows the largest amount of space allocated so far during execution of
   --  the program to the current secondary stack, i.e. the secondary stack
   --  for the current task.

   --  generic
   --     with procedure Put_Line (S : String);
   --  procedure SS_Info;
   --  Debugging procedure used to print out secondary Stack allocation
   --  information. This procedure is generic in order to avoid a direct
   --  dependance on a particular IO package.

   function Get_Sec_Stack_Addr return Address;
   pragma Export (C, Get_Sec_Stack_Addr, "__gnat_get_secondary_stack");

private
   SS_Pool : Integer := 0;
   --  Unused entity that is just present to ease the sharing of the pool
   --  mechanism for specific allocation/deallocation in the compiler

   type SS_Ptr is new SSE.Integer_Address;
   --  Stack pointer value for secondary stack

   type Mark_Id is record
      Sstk : Address;
      Sptr : SS_Ptr;
   end record;
   --  A mark value contains the address of the secondary stack structure
   --  and a stack pointer value corresponding to the point of the mark call.

end System.Secondary_Stack;
