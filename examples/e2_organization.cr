class E2::Organization
  property name : String
  property persons : Int32

  def initialize(@name : String, @persons : Int32); end
end

class E2::Enterprise < E2::Organization
  property type : String

  def initialize(@name : String, @persons : Int32, @type : String); end
end

class E2::Bank < E2::Organization
  property clients : Int32

  def initialize(@name : String, @persons : Int32, @clients : Int32); end
end
