require "./annotations"
require "./generators/**"
require "./../examples/**"

# TODO: Write documentation for `Cruml`
module Cruml
  VERSION = "0.1.0"

  Cruml::ClassReflector.list_classes_and_methods
end
