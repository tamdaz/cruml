## Introduction

A class diagram can be generated thanks to two constants:

- `::CRUML_FILTER_PREFIX`
- `::CRUML_OUT_DIR`

The `::CRUML_FILTER_PREFIX` constant allows to select the modules you want to generate. For example,
The `::CRUML_OUT_DIR` constant enables to define a path where you want to save your diagram.

## Example

```crystal
# Classes and interfaces that are located in this module are selected.
::CRUML_FILTER_PREFIX = "Project::Entities"

# This path can be relative or absolute.
::CRUML_OUT_DIR = "./out/"

# Start generating a UML class diagram by calling the `run` static method.
Cruml.run
```

!!! info
    It's recommended to create another file which will be used to generate the class diagram.

```
project
├── lib
├── out                     <== directory where the class diagram will be saved.
├── spec
└── src
    ├── project.cr          <== Your code source
    └── generate_diagram.cr <== Used to generate diagram only.
```

In the `generate_diagram.cr` file, you must import your entry file (e.g: `product`).
```crystal title="generate_diagram.cr"
require "./project"
require "./entities/**"

::CRUML_FILTER_PREFIX = "Project"
::CRUML_OUT_DIR       = "./out/" 

Cruml.run
```

In the main entry file, you can include many classes as you want.
```crystal title="project.cr"
module Project
  VERSION = "1.0.0"

  # Own classes...
end
```
