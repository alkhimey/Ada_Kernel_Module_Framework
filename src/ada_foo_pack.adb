--  with Ada.Characters.Latin_1;

with Linux.Kernel_IO;

package body Ada_Foo_Pack is

   type Color_Type is (RED, BLACK, PURPLE_BLUE);
   type Fixed_Point_Type is delta 0.1 range -100.0 .. 100.0;
   type Unsigned_Type is mod 2**32;
   type Float_Type is digits 6;

   procedure Ada_Foo is
      S1 : String := Integer'Image (42) & Character'Val (0);
      S2 : String := Color_Type'Image (PURPLE_BLUE) & Character'Val (0);
      S3 : String := Boolean'Image(True)    & Character'Val (0);
      S4 : String := Fixed_Point_Type'Image(4.2) & Character'Val (0);
      S5 : String := Integer'Image(-42) & Character'Val (0);
      S6 : String := Unsigned_Type'Image(42) & Character'Val (0);
      S7 : String := Float_Type'Image(424.242) & Character'Val (0);
   begin
      Linux.Kernel_IO.Put_Line (S1);
      Linux.Kernel_IO.Put_Line (S2);
      Linux.Kernel_IO.Put_Line (S3);
      Linux.Kernel_IO.Put_Line (S4);
      Linux.Kernel_IO.Put_Line (S5);
      Linux.Kernel_IO.Put_Line (S6);
      Linux.Kernel_IO.Put_Line (S7);

      --  Linux.Kernel_IO.Put_Line(Item => "C Bindings are working...");
   end Ada_Foo;

begin
   null;
end Ada_Foo_Pack;
