with Interfaces.C;


package Ada_Foo_Pack is

   procedure Ada_Foo;

   --  Later, we will use Interfaces.C properly
   --  type String2 is array (Positive range <>) of aliased Character;
   --  for String2'Component_Size use 8; -- 8 bits

   procedure Print_Kernel (S : in out String);

private
   pragma Export
      (Convention    => C,
       Entity        => Ada_Foo,
       External_Name => "ada_foo");

   pragma Import
     (Convention    => C,
      Entity        => Print_Kernel,
      External_Name => "print_kernel");

end Ada_Foo_Pack;
