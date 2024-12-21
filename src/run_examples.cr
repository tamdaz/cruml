require "./cruml"
require "./../examples/*"

::CRUML_FILTER_PREFIX = "Example::E1"
::CRUML_OUT_DIR       = "./out/"

Cruml.run
