module Cruml::Annotation
  # Allows to hide a class during the UML diagram generation.
  # ```
  # @[Cruml::Annotation::Invisible]
  # class Secret
  #   getter api_token : String
  # end
  # ```
  annotation Invisible; end

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
