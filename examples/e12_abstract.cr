abstract class E12::Shape
  abstract def area : Float64
  abstract def perimeter : Float64
end

class E12::Circle < E12::Shape
  property radius : Float64

  def initialize(@radius : Float64); end

  def area : Float64
    Math::PI * @radius ** 2
  end

  def perimeter : Float64
    2 * Math::PI * @radius
  end
end

class E12::Rectangle < E12::Shape
  property width : Float64
  property height : Float64

  def initialize(@width : Float64, @height : Float64); end

  def area : Float64
    @width * @height
  end

  def perimeter : Float64
    2 * (@width + @height)
  end
end
