@[Cruml::Annotation::AsInterface]
abstract class Example::Test::Shape
  abstract def area : Float64
  abstract def perimeter : Float64
end

class Example::Test::Rectangle < Example::Test::Shape
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

class Example::Test::Circle < Example::Test::Shape
  getter radius : Float64

  def initialize(@radius : Float64); end

  def area : Float64
    Math::PI * (@radius ** 2)
  end

  def perimeter : Float64
    2 * Math::PI * @radius
  end
end

class Example::Test::Triangle < Example::Test::Shape
  property base : Float64
  property height : Float64

  def initialize(@base : Float64, @height : Float64); end

  def area : Float64
    0.5 * @base * @height
  end

  def perimeter : Float64
    3 * @base
  end
end

@[Cruml::Annotation::AsInterface]
abstract class Example::Test::Solid
  abstract def volume : Float64
  abstract def surface_area : Float64
end

class Example::Test::Cube < Example::Test::Solid
  property side_length : Float64

  def initialize(@side_length : Float64); end

  def volume : Float64
    @side_length ** 3
  end

  def surface_area : Float64
    6 * (@side_length ** 2)
  end
end

class Example::Test::Sphere < Example::Test::Solid
  getter radius : Float64

  def initialize(@radius : Float64); end

  def volume : Float64
    (4.0 / 3.0) * Math::PI * (@radius ** 3)
  end

  def surface_area : Float64
    4 * Math::PI * (@radius ** 2)
  end
end

abstract class Example::Test::Vehicle
  abstract def fuel_efficiency : Float64
end

class Example::Test::Car < Example::Test::Vehicle
  property fuel_consumption : Float64

  def initialize(@speed : Float64, @fuel_consumption : Float64)
    super(@speed)
  end

  def fuel_efficiency : Float64
    100.0 / @fuel_consumption
  end
end

class Example::Test::Bicycle < Example::Test::Vehicle
  def initialize(@speed : Float64)
    super(@speed)
  end

  def fuel_efficiency : Float64
    Float64::INFINITY
  end
end
