package Ada_Foo_Pack is

   function Ada_Foo return Integer;

private
   pragma Export
      (Convention    => C,
       Entity        => Ada_Foo,
       External_Name => "ada_foo");
end Ada_Foo_Pack;
