class Example::E3::Universe
  def initialize(@size : Int32); end
end

class Example::E3::Galaxy < Example::E3::Universe
  def initialize(@size : Int32); end
end

class Example::E3::BlackHole < Example::E3::Galaxy
  def initialize(@size : Int32); end
end

class Example::E3::Planet < Example::E3::Galaxy
  def initialize(@size : Int32); end
end

class Example::E3::Star < Example::E3::Galaxy
  def initialize(@size : Int32); end
end
