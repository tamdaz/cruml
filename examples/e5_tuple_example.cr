class Example::E5::Person
  def initialize(@name : String, @age : Int32, @address : String, @phone : String)
  end

  def details : Tuple(String, Int32, String, String)
    {@name, @age, @address, @phone}
  end
end

class Example::E5::Book
  def initialize(@title : String, @publisher : String, @isbn : String, @year : Int32)
  end

  def info : Tuple(String, String, String, Int32)
    {@title, @publisher, @isbn, @year}
  end
end

class Example::E5::Coordinates
  def initialize(@latitude : Float64, @longitude : Float64, @altitude : Float64, @accuracy : Float64)
  end

  def location : Tuple(Float64, Float64, Float64, Float64)
    {@latitude, @longitude, @altitude, @accuracy}
  end
end
