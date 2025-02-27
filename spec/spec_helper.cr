require "spec"
require "./../src/entities/**"
require "./../src/renders/config"

def parse_module_helper : Nil
  code = <<-CRYSTAL
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
  CRYSTAL

  ast = Crystal::Parser.parse(code)
  tx = Cruml::Transformer.new
  ast.transform(tx)
end
