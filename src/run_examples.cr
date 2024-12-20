require "./cruml"
require "./../examples/*"

::CRUML_FILTER_PREFIX = "Example::E4"
::CRUML_OUT_DIR       = "./out/"

Cruml.run
