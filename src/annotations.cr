module Cruml::Annotation
  # Allows to define informations about class.
  # ```
  # @[Cruml::Annotation::Class(name: "A person")]
  # class Person
  #   property name : String
  # end
  # ```
  annotation Class; end

  # Allows to hide a class during the UML diagram generation.
  # ```
  # @[Cruml::Annotation::Invisible]
  # class Secret
  #   getter api_token : String
  # end
  # ```
  annotation Invisible; end

  # Allows to set a color for a specific class.
  # ```
  # @[Cruml::Annotation::Color("#ff0000")]
  # class Organization
  #   property name : String
  #   property persons : Array(Person)
  # end
  # ```
  annotation Color; end

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
