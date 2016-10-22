package body Ada_Foo_Pack is

   Ultimate_Unswer : Integer := 0;

   function Ada_Foo return Integer is
   begin
      --  delay 0.001;
      return Ultimate_Unswer;

   end Ada_Foo;

begin

   --  This line of code will run during elaboration
   --
   Ultimate_Unswer := 42;

end Ada_Foo_Pack;
