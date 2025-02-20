module ModuleOne
  def greet_one : String
    "Hello from ModuleOne"
  end
end

module ModuleTwo
  def greet_two : String
    "Hello from ModuleTwo"
  end
end

class MyClass
  include ModuleOne
  include ModuleTwo

  def initialize(@my_ivar : String); end
end
