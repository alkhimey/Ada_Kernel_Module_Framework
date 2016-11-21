--  with Ada.Characters.Latin_1;

package body Ada_Foo_Pack is

   --  Ultimate_Unswer : Integer := 0;pragma Warnings (Off
   pragma Warnings (Off);
   Ultimate_Answer : String := "Fourty Two" & Character'Val (0);
   pragma Warnings (On);

   I : constant Integer := 42;

   procedure Ada_Foo is
      S : String := Integer'Image (I);
   begin
      --  Print_Kernel ("Fourty Two");
      --  Print_Kernel (Ultimate_Answer);
      --  Print_Kernel ("Fourty Two");
      Print_Kernel (S);
      --  S := Integer'Image (-42);
      --  Print_Kernel (S);

      --  S := Integer'Image (0);
      --  Print_Kernel (S);

   end Ada_Foo;

begin
   null;
   --  This line of code will run during elaboration
   --
   --  Ultimate_Unswer := "Fourty Two" & Character'Val (0);

end Ada_Foo_Pack;
