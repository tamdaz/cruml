# Test class methods (self methods)
class E17::Configuration
  class_property instance : E17::Configuration?

  property? debug : Bool
  property log_level : String

  def initialize(@debug : Bool = false, @log_level : String = "info"); end

  def self.setup : E17::Configuration
    @@instance ||= new
  end

  def self.reset : Void
    @@instance = nil
  end

  def self.current : E17::Configuration
    @@instance || setup
  end
end

class E17::Factory
  def self.create_user(name : String, email : String) : E17::User
    E17::User.new(name, email)
  end

  def self.create_admin(name : String, email : String) : E17::Admin
    E17::Admin.new(name, email, true)
  end

  def self.build_from_hash(data : Hash(String, String)) : E17::User
    create_user(data["name"], data["email"])
  end
end

class E17::User
  property name : String
  property email : String

  def initialize(@name : String, @email : String); end

  def self.find_by_email(email : String) : E17::User?
    nil
  end

  def self.all : Array(E17::User)
    [] of E17::User
  end
end

class E17::Admin < E17::User
  property? super_admin : Bool

  def initialize(@name : String, @email : String, @super_admin : Bool = false)
    super(@name, @email)
  end

  def self.count : Int32
    all.size
  end
end
