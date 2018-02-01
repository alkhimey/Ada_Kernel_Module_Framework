--  with Interfaces.C;

package Ada_Foo_Pack is

   procedure Ada_Foo;
   procedure Ada_Unfoo;

private
   pragma Export
      (Convention    => C,
       Entity        => Ada_Foo,
       External_Name => "ada_foo");

   pragma Export
      (Convention    => C,
       Entity        => Ada_Unfoo,
       External_Name => "ada_unfoo");

end Ada_Foo_Pack;
