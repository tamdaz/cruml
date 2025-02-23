module E10::ModuleOne
  def greet_one : String
    "Hello from ModuleOne"
  end
end

module E10::ModuleTwo
  def greet_two : String
    "Hello from ModuleTwo"
  end
end

class E10::MyClass
  include E10::ModuleOne
  include E10::ModuleTwo

  def initialize(@my_ivar : String); end
end
