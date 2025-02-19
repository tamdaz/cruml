class E7::A
  def name : String
    "John Doe"
  end
end

class E7::B < E7::A
  def name : String
    "John Doe"
  end
end

class E7::C < E7::A
  def name : String
    "John Doe"
  end
end

class E7::D < E7::B
  def name : String
    "John Doe"
  end
end

class E7::E < E7::B
  def name : String
    "John Doe"
  end
end

class E7::F < E7::C
  def name : String
    "John Doe"
  end
end

class E7::G < E7::C
  def name : String
    "John Doe"
  end
end
