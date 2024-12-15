module Cruml::Annotation
  # Allows to define informations about class.
  annotation Class; end

  # Allows to hide a class during the UML diagram generation.
  annotation Invisible; end

  # Allows to set a color for a specific class.
  annotation Color; end

  # Allows to set a class as an interface. Useful for an abstract class
  # who implements the methods signature.
  annotation AsInterface; end
end
