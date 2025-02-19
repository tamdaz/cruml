abstract class E8::Shape
  abstract def area : Float64
  abstract def perimeter : Float64
  abstract def draw : Void
end

class E8::Circle < E8::Shape
  property radius : Float64

  def initialize(@radius : Float64); end

  def area : Float64
    Math::PI * @radius ** 2
  end

  def perimeter : Float64
    2 * Math::PI * @radius
  end

  def draw : Void
    puts "Drawing a circle with radius #{@radius}"
  end
end

class E8::Rectangle < E8::Shape
  property width : Float64
  property height : Float64

  def initialize(@width : Float64, @height : Float64); end

  def area : Float64
    @width * @height
  end

  def perimeter : Float64
    2 * (@width + @height)
  end

  def draw : Void
    puts "Drawing a rectangle with width #{@width} and height #{@height}"
  end
end

class E8::Triangle < E8::Shape
  property base : Float64
  property height : Float64

  def initialize(@base : Float64, @height : Float64); end

  def area : Float64
    0.5 * @base * @height
  end

  def perimeter : Float64
    3 * @base
  end

  def draw : Void
    puts "Drawing a triangle with base #{@base} and height #{@height}"
  end
end
