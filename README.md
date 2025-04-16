# cruml

![GitHub Release](https://img.shields.io/github/v/release/tamdaz/cruml)
[![ci](https://github.com/tamdaz/cruml/actions/workflows/crystal.yml/badge.svg?branch=main)](https://github.com/tamdaz/cruml/actions/workflows/crystal.yml)

![crystal doc info](https://img.shields.io/badge/CrystalDoc.info-2E1052?logo=crystal&style=for-the-badge)

> [!WARNING]
> This tool is under development, it is not completely finished.

**cruml** *(**Cr**ystal **UML**)* is a tool that allows to generate an UML diagram. This is useful for any Crystal projects.

![uml_class_diagram](img/diagram.png)

> An UML class diagram representing the parent class linked to child classes.

## Requirements

To do this, you should have d2 installed.

Documentation source : https://d2lang.com/tour/install#install-script.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
development_dependencies:
  cruml:
    github: tamdaz/cruml
```

2. Run `shards install`.

Once this tool is installed, this will build a binary into `bin/` directory in your project.

## Usage

```
Usage : cruml generate [arguments] -- [options]
    -v, --version                    Show the version
    -h, --help                       Show this help
    --verbose                        Enable verbose
    --dark-mode                      Set to dark mode
    --no-color                       Disable color output
    --path=PATH                      Path to specify
    --output-dir=DIR                 Directory path to save diagrams
```

## Examples

For example, to generate a diagram with Crystal files in the `src/models` directory:

```sh
bin/cruml generate --path="src/models"
```

To generate a diagram with one Crystal file:

```sh
bin/cruml generate --path="src/models/user.cr"
```

> [!TIP]
> You can use multiple `--path` flag to include several files or directories.

In addition, you can change the diagram theme thanks to `--dark-mode` flag:

```sh
bin/cruml generate --path="src/models" --dark-mode
```

If you don't want to colorize the diagram, you can use the `--no-color` flag:

```sh
bin/cruml generate --path="src/models" --no-color
```

## Contributing

1. Fork it (<https://github.com/tamdaz/cruml/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tamdaz](https://github.com/tamdaz) - creator and maintainer
