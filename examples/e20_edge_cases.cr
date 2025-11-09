class E20::EmptyClass; end

class E20::OnlyClassMethods
  def self.utility_method : String
    "utility"
  end

  def self.another_utility(arg : Int32) : Bool
    arg > 0
  end
end

abstract class E20::AbstractWithImplementations
  abstract def abstract_method : Void

  def concrete_method : String
    "implemented"
  end

  def another_concrete : Int32
    42
  end
end

class E20::ImplementsAbstract < E20::AbstractWithImplementations
  def abstract_method : Void
    puts "implemented"
  end
end

class E20::SingleProperty
  property value : String

  def initialize(@value : String); end
end

class E20::DeepInheritance < E20::ImplementsAbstract
  property data : String

  def initialize(@data : String); end
end

abstract class E20::Level1
  abstract def level1_method : Void
end

abstract class E20::Level2 < E20::Level1
  abstract def level2_method : Void

  def level1_method : Void
    puts "Level 1 implemented in Level 2"
  end
end

class E20::Level3 < E20::Level2
  def level2_method : Void
    puts "Level 2 implemented"
  end
end

class E20::MultipleInitializers
  property name : String
  property age : Int32
  property email : String?

  def initialize(@name : String)
    @age = 0
  end

  def initialize(@name : String, @age : Int32); end

  def initialize(@name : String, @age : Int32, @email : String); end
end
