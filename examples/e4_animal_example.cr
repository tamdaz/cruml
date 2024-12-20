@[Cruml::Annotation::AsInterface]
abstract class Example::E4::Shape
  abstract def area : Float64
end

class Example::E4::Rectangle < Example::E4::Shape
  def area : Float64
    0
  end
end

class Example::E4::Square < Example::E4::Shape
  def area : Float64
    0
  end
end
