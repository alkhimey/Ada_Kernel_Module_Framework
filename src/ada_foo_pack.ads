--  with Interfaces.C;

package Ada_Foo_Pack is

   procedure Ada_Foo;

private
   pragma Export
      (Convention    => C,
       Entity        => Ada_Foo,
       External_Name => "ada_foo");

end Ada_Foo_Pack;
