class E3::Universe
  def initialize(@size : Int32); end
end

class E3::Galaxy < E3::Universe
  def initialize(@size : Int32); end
end

class E3::BlackHole < E3::Galaxy
  def initialize(@size : Int32); end
end

class E3::Planet < E3::Galaxy
  def initialize(@size : Int32); end
end

class E3::Star < E3::Galaxy
  def initialize(@size : Int32); end
end
