# cruml

![GitHub Release](https://img.shields.io/github/v/release/tamdaz/cruml)
[![ci](https://github.com/tamdaz/cruml/actions/workflows/crystal.yml/badge.svg?branch=main)](https://github.com/tamdaz/cruml/actions/workflows/crystal.yml)
[![ci-docs](https://github.com/tamdaz/cruml/actions/workflows/ci-docs.yml/badge.svg)](https://github.com/tamdaz/cruml/actions/workflows/ci-docs.yml)

> [!WARNING]
> This tool is under development, it is not completely finished.

**cruml** *(**Cr**ystal **UML**)* is a tool that allows to generate an UML diagram. This is useful for any Crystal projects.

![uml_class_diagram](img/diagram.png)

> A class diagram representing the child classes linked to the parent class.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
development_dependencies:
  cruml:
    github: tamdaz/cruml
    branch: main
```

2. Run `shards install`, once this tool is installed, it will build a binary in the `bin/` directory located in your project.

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

To generate a diagram with all Crystal files in the `src/classes` directory:

```
bin/cruml generate --path="src/classes"
```

To generate a diagram with one Crystal file:

```
bin/cruml generate --path="src/classes/my_class.cr"
```

> [!TIP]
> You can use multiple `--path` flag to include several files.

In addition, you can change the diagram theme thanks to `--dark-mode` flag:

```
bin/cruml generate --path="src/classes" --dark-mode
```

If you don't want to colorize the diagram, you can use the `--no-color` flag:

```
bin/cruml generate --path="src/classes" --no-color
```

## Contributing

1. Fork it (<https://github.com/tamdaz/cruml/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tamdaz](https://github.com/tamdaz) - creator and maintainer
