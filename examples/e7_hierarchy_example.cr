class Parent
  def name : String
    "John Doe"
  end
end

class FirstChild < Parent
  def name : String
    "John Doe"
  end
end

class SecondChild < Parent
  def name : String
    "John Doe"
  end
end

class FirstSubChild < FirstChild
  def name : String
    "John Doe"
  end
end

class SecondSubChild < FirstChild
  def name : String
    "John Doe"
  end
end

class ThirdSubChild < SecondChild
  def name : String
    "John Doe"
  end
end

class FourthSubChild < SecondChild
  def name : String
    "John Doe"
  end
end
