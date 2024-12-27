# Contains a set of annotations for adding metadata to a class.
module Cruml::Annotation
  # Ensures that a class is considered as an interface.
  # This is useful when an interface implements the methods signature.
  #
  # Example:
  # ```
  # @[Cruml::Annotation::AsInterface]
  # abstract class Animal
  #   abstract def walk : Nil
  #   abstract def eat : Nil
  # end
  # ```
  annotation AsInterface; end
end
