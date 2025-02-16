class Example::E4::Container
  def to_s : String
    "Container"
  end
end

# Define a generic class Box that can hold any type of value and inherits from Container
class Example::E4::Box(T) < Example::E4::Container
  property value : T

  def initialize(value : T)
    @value = value
  end

  def to_s : String
    "Box containing: #{@value}"
  end
end

# Define a generic class Pair that holds two values of potentially different types and inherits from Container
class Example::E4::Pair(A, B) < Example::E4::Container
  property first : A
  property second : B

  def initialize(first : A, second : B)
    @first = first
    @second = second
  end

  def to_s : String
    "Pair: (#{@first}, #{@second})"
  end
end
