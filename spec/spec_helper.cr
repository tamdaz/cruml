require "spec"
require "./../src/cruml"
require "./../examples/*"

::CRUML_FILTER_PREFIX = "Example::Test"
::CRUML_OUT_DIR       = "/tmp"

def get_reflection
  Cruml::Reflection.start
end
