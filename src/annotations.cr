module Cruml::Annotation
  # Allows to set a class as an interface. Useful for an abstract class
  # who implements the methods signature.
  # ```
  # @[Cruml::Annotation::AsInterface]
  # abstract class Animal
  #   abstract def walk : Nil
  #   abstract def eat : Nil
  # end
  # ```
  annotation AsInterface; end
end
