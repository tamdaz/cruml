class E1::Person
  property name : String
  property age : Int8

  def initialize(@name : String, @age : Int8); end

  protected def major? : Bool
    @age >= 18
  end
end

class E1::Employee < E1::Person
  property wages : Int16

  def initialize(@name : String, @age : Int8, @wages : Int16); end
end

class E1::Customer < E1::Person
  def initialize(@name : String, @age : Int8); end
end
