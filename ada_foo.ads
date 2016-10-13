function Ada_Foo return Integer;

pragma Export
   (Convention    => C,
    Entity        => Ada_Foo,
    External_Name => "ada_foo" );
