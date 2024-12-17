require "./../src/cruml"
require "./e1_person_example"
require "./e2_organization_example"
require "./e3_universe_example"

::CRUML_FILTER_PREFIX = "Example::E1"
::CRUML_OUT_DIR = "./out/"

Cruml.run
