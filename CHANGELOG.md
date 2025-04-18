# Changelog

## [0.7.0](https://github.com/tamdaz/cruml/releases/tag/0.7.0) - 2025-04-18

## Added

- Setup the VSCode config to easily debug (@tamdaz)(#27)
- Setup the `--verbose` flag (@tamdaz)(#28)
- Add the `PULL_REQUEST_TEMPLATE.md` file. (@tamdaz)(#39)
- Setup the YML config (@tamdaz)(#43)
- Display class vars (@tamdaz)(#45)
- Setup the YML config file generator. (@tamdaz)(#46)

## Changed

- Update the `.gitignore` file. (@tamdaz)(#25)
- Set the ameba version to `~> 1.6.0` (@tamdaz)(#26)
- Refactor code in the `src/render` directory. (@tamdaz)(#29)
- Integrate d2lang into cruml (@tamdaz)(#30)
- Rename the abstract class to `AbstractShape` (@tamdaz)(#31)
- Move the console file into `src/commands` directory (@tamdaz)(#32)
- Refactor classifiers (@tamdaz)(#34)
- Improve docs (@tamdaz)(#35)
- Update the README for the next version. (@tamdaz)(#47)
- Change the Crystal version in the `shard.yml` file. (@tamdaz)(#37)
- Improve CI workflow. (@tamdaz)(#40)

## Fixed

- Escape some characters (`|` and `:`) in the argument type (@tamdaz)(#38)
- Refactor code in the transformer and the class list. (@tamdaz)(#44)

## Removed

- Remove config for formatting HTML files (@tamdaz)(#36)

## [0.6.2](https://github.com/tamdaz/cruml/releases/tag/0.6.2) - 2025-04-15

## Fixed

- Refactor code in the `src/render` directory. (@tamdaz)(#29)

## [0.6.1](https://github.com/tamdaz/cruml/releases/tag/0.6.1) - 2025-02-24

## Setup

- Setup configuration to debug. (@tamdaz)(#21)

## Changed

- Refactor the code and docs. (@tamdaz)(#19)(#20)

## Fixed

- Fix namespace prefix. (@tamdaz)(#22)

## [0.6.0](https://github.com/tamdaz/cruml/releases/tag/0.6.0) - 2025-02-24

## Added

* Add an interface (@tamdaz)(#16)

## Changed

* Rename the `#find_by_name!` static method to `#find_by_name` (@tamdaz)(#15)

## Fixed

* Add missing code to set a module as an interface (@tamdaz)(#18)
* Namespace did not accept special characters (@tamdaz)(#14)
* Fix namespaces (@tamdaz)(#17)

## [0.5.0](https://github.com/tamdaz/cruml/releases/tag/0.5.0) - 2025-02-22

**BREAKING CHANGE**: cruml is no longer a library, this is now an exectuable tool.

## Added

- Add the `--output-dir` flag by (@tamdaz)(#10)
- Add a config to format the HTML files (dev only). by (@tamdaz)(#7)
- Add the specs by (@tamdaz)(#6)
- Add a CLI by @tamdaz in [#5](https://github.com/tamdaz/cruml/pull/5/files#diff-1141c7f214dfe9fce761897ef05ab40a28bd6f97fc0651111c48057ffdf36021)

## Changed

- **Breaking**: Use the Crystal Compiler API instead of macros by (@tamdaz)(#5)
- Refactor the code located in the `src/render` directory. by (@tamdaz)(#8)

## Fixed

- Indent the Mermaid code. by (@tamdaz)(#11)
- Fixed a bug with special characters in class names. by (@tamdaz)(#12)

## Removed

- Remove the crystalline config by (@tamdaz)(#9)

## [0.4.0](https://github.com/tamdaz/cruml/releases/tag/0.4.0) - 2025-02-17

## Added

- Add examples to represent generics and tuples. (#4) @tamdaz
- Add arguments to methods. ([f152429](https://github.com/tamdaz/cruml/commit/f152429686be94a26e4a9a0a6c6d8932f27f83a2))([8d8f339](https://github.com/tamdaz/cruml/commit/8d8f339aa5fe4e27b90fd2a36b8285801e08ede4))([0e7e478](https://github.com/tamdaz/cruml/commit/0e7e478e9b319066044f4ce36904aa54a67e6788)) @tamdaz

## Changed

- **Breaking Change**: Rename the class to Cruml::Renders::DiagramRender ([e6638dd](https://github.com/tamdaz/cruml/commit/e6638dd833470087ade9960b61e1151a3083c127)) @tamdaz.

## Fixed

- Fix the generic format. (#3) @tamdaz

## [0.3.0](https://github.com/tamdaz/cruml/releases/tag/0.3.0) - 2024-12-28

### Added

- Add documentations to this library. ([0f58256](https://github.com/tamdaz/cruml/commit/0f582563d28337437e3a27344b260d273d8ad503)) @tamdaz

### Fixed

- Fix the scope for the class diagram. ([e699b97](https://github.com/tamdaz/cruml/commit/e699b9791f805d549f8cbaafb33e3bc3ff22cc9a))([d69028d](https://github.com/tamdaz/cruml/commit/d69028d9286da3c758c26032f32fbd07d5a73711)) @tamdaz
- Fix a bug where generics was not correctly formatted. ([d51251e](https://github.com/tamdaz/cruml/commit/d51251e56480c80ecab32aa2f8e294541d4b485d)) @tamdaz

### Removed

- Disable the zoom and bounds. ([215cdde](https://github.com/tamdaz/cruml/commit/215cdde9194244f94a2904dd7baab230eacd4d6b)) @tamdaz

## [0.2.0](https://github.com/tamdaz/cruml/releases/tag/0.2.0) - 2024-12-22

### Added

- Add the `Cruml::ClassList` class ([fc5a6f3](https://github.com/tamdaz/cruml/commit/fc5a6f3dac155c11e1a840d2869dbcd13837978a)) @tamdaz 
- Add entities to reflect classes, instance vars and methods. ([89e6ae6](https://github.com/tamdaz/cruml/commit/89e6ae614da491acf452b0b6a83350555d8fb291)) @tamdaz 

### Changed

- Optimize the macro code in the [`src/reflection.cr`](https://github.com/tamdaz/cruml/commit/e24b77ecac065356b471c02c2c3a33a3738d3027) file. (#1)(0a1660d) @tamdaz 
- Refactor the `Cruml.run` static method. ([8ed873a](https://github.com/tamdaz/cruml/commit/8ed873a0b8cf173e77dd91013e22db4fa3207846)) @tamdaz 
- Refactor the `Cruml::DiagramRender` class. ([7aa8a4a](https://github.com/tamdaz/cruml/commit/7aa8a4a683568d1fbb38056acbe178d79bebe96f)) @tamdaz 
- Replace parenthesis by rafters for the return type. ([9507dae](https://github.com/tamdaz/cruml/commit/9507dae6311d0e1c2aa08acaa76d59adf0e0328d)) @tamdaz 

### Fixed

- Fix inherit class. ([d9fe043](https://github.com/tamdaz/cruml/commit/d9fe0436a86c02ecc02de2217fdb41f0ba5309d8)) @tamdaz 

### Removed

- Remove the `@[Cruml::Annotation::Invisible]` annotation. ([0a1660d](https://github.com/tamdaz/cruml/commit/0a1660d00515ac98838e765273a82d8871d11c17)) @tamdaz 

## [0.1.0](https://github.com/tamdaz/cruml/releases/tag/0.1.0) - 2024-12-21

Initial release