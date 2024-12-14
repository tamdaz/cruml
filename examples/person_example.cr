class Example::Person
  property name : String
  property age : Int8

  def initialize(@name : String, @age : Int8); end

  def is_major : Bool
    @age >= 18
  end
end

class Example::Employee < Example::Person
  property wages : Int16

  def initialize(@name : String, @age : Int8, @wages : Int16); end
end
