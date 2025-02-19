class E9::GetterExample
  getter value : Int32

  def initialize(@value : Int32); end
end

class E9::PropertyExample
  property value : Int32

  def initialize(@value : Int32); end
end

class E9::SetterExample
  setter value : Int32

  def initialize(@value : Int32); end
end

class E9::NullableGetterExample
  getter? value : Int32?

  def initialize(@value : Int32?); end
end

class E9::NullablePropertyExample
  property? value : Int32?

  def initialize(@value : Int32?); end
end
