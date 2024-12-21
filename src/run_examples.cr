require "./cruml"
require "./../examples/*"

::CRUML_FILTER_PREFIX = "Example"
::CRUML_OUT_DIR       = "./out/"

Cruml.run
