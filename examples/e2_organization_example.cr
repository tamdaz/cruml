# Example 2 : An organization itself
class Example::E2::Organization
  property name : String
  property persons : Int32

  def initialize(@name : String, @persons : Int32); end
end

# Example 2 : Enterprise as an organization
class Example::E2::Enterprise < Example::E2::Organization
  property type : String

  def initialize(@name : String, @persons : Int32, @type : String); end
end

# Example 2 : Bank as an organization
class Example::E2::Bank < Example::E2::Organization
  property clients : Int32

  def initialize(@name : String, @persons : Int32, @clients : Int32); end
end
