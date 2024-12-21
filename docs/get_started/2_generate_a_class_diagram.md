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