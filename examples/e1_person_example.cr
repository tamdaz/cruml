# Example 1 : A person
class Example::E1::Person
  property name : String
  property age : Int8

  def initialize(@name : String, @age : Int8); end

  def is_major : Bool
    @age >= 18
  end
end

# Example 1 : An employee
class Example::E1::Employee < Example::E1::Person
  property wages : Int16

  def initialize(@name : String, @age : Int8, @wages : Int16); end
end
