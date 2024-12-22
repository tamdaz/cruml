# Changelog

## [0.2.0](https://github.com/tamdaz/cruml/releases/tag/0.1.0) - 2024-12-22
### Added
- Add the `Cruml::ClassList` class ([fc5a6f3](https://github.com/tamdaz/cruml/commit/fc5a6f3dac155c11e1a840d2869dbcd13837978a)) @tamdaz 
- Add entities to reflect classes, instance vars and methods. ([89e6ae6](https://github.com/tamdaz/cruml/commit/89e6ae614da491acf452b0b6a83350555d8fb291)) @tamdaz 

### Changed
- Optimize the macro code in the [`src/reflection.cr`](https://github.com/tamdaz/cruml/commit/e24b77ecac065356b471c02c2c3a33a3738d3027) file. (#1)(0a1660d) @tamdaz 
- Refactor the `Cruml.run` static method. ([8ed873a](https://github.com/tamdaz/cruml/commit/8ed873a0b8cf173e77dd91013e22db4fa3207846)) @tamdaz 
- Refactor the `Cruml::DiagramRender` class. ([7aa8a4a](https://github.com/tamdaz/cruml/commit/7aa8a4a683568d1fbb38056acbe178d79bebe96f)) @tamdaz 
- Replace paranthesis by rafters for the return type. ([9507dae](https://github.com/tamdaz/cruml/commit/9507dae6311d0e1c2aa08acaa76d59adf0e0328d)) @tamdaz 

### Fixed
- Fix inherit class. ([d9fe043](https://github.com/tamdaz/cruml/commit/d9fe0436a86c02ecc02de2217fdb41f0ba5309d8)) @tamdaz 

### Removed
- Remove the `@[Cruml::Annotation::Invisible]` annotation. ([0a1660d](https://github.com/tamdaz/cruml/commit/0a1660d00515ac98838e765273a82d8871d11c17)) @tamdaz 

## [0.1.0](https://github.com/tamdaz/cruml/releases/tag/0.1.0) - 2024-12-21
Initial release