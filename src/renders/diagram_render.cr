require "ecr"

# Consists of generating a class diagram.
# See https://mermaid.js.org/syntax/classDiagram.html
class Cruml::Renders::DiagramRender
  @code : String = "classDiagram\n"

  # The directory path must be passed as argument when instantiating this class.
  def initialize(path_dir : Path)
    @path_dir = path_dir
  end

  # Generate a class diagram.
  # A `Cruml::ClassList` class must be passed as parameter
  def generate(class_list : Cruml::ClassList) : Nil
    class_list.classes.each do |class_info|
      add_inherit_class(class_info.inherit_classes)
      add_class(class_info)
    end
    set_diagram_colors
  end

  # Creates a link between the parent and child classes.
  # If the parent class type is an interface, the arrow would look like : <|--
  # If the parent class type is abstract or normal, the arrow would look like : <|--
  # See https://mermaid.js.org/syntax/classDiagram.html#defining-relationship for more info.
  private def add_inherit_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, class_type|
      case class_type
      when :interface
        @code += "#{class_name.split("::")[-1]} <|.. #{subclass_name.split("::")[-1]}\n"
      when :abstract
        @code += "#{class_name.split("::")[-1]} <|-- #{subclass_name.split("::")[-1]}\n"
      when :class
        @code += "#{class_name.split("::")[-1]} <|-- #{subclass_name.split("::")[-1]}\n"
      end
    end
  end

  # Creates a class with a whole set of instance variables and methods.
  # See https://mermaid.js.org/syntax/classDiagram.html#class for more info.
  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    # namespace = class_info.name.split("::")[0..-2].join("")
    short_class_name = class_info.name.split("::")[-1]

    case class_info.type
    when :interface then @code += "&lt;&lt;interface&gt;&gt; #{short_class_name}\n"
    when :abstract  then @code += "&lt;&lt;abstract&gt;&gt; #{short_class_name}\n"
    end

    case class_info.type
    when :interface then @code += "  class #{short_class_name}:::interface {\n"
    when :abstract  then @code += "  class #{short_class_name} {\n"
    when :class     then @code += "  class #{short_class_name} {\n"
    end

    unless class_info.instance_vars.size == 0
      class_info.instance_vars.each do |instance_var|
        name = instance_var[-2]
        type = instance_var[-1]
        @code += "    -#{name} : #{type}\n"
      end
    end

    unless class_info.methods.size == 0
      class_info.methods.each do |method|
        literal_scope = case method.scope
                        when :public    then '+'
                        when :protected then '#'
                        when :private   then '-'
                        else                 '+'
                        end
        @code += "    #{literal_scope}#{method.name}(#{method.generate_args}) "

        if method.return_type =~ /\(.*\)/
          @code += " : "
        end

        @code += "#{method.return_type}\n"
      end
    end

    @code += "  }\n" # end class
  end

  # Define the style properties for the class diagram.
  # See https://mermaid.js.org/syntax/classDiagram.html#css-classes for more info.
  private def set_diagram_colors : Nil
    @code += "classDef default fill:#2e1065,color:white\n"
    @code += "classDef interface fill:#365314,color:white"
    @code += "namespaceDef default fill:#ffffff"
  end

  # Save the class diagram as a HTML file.
  def save : Nil
    output = ECR.render("src/renders/diagram.ecr")
    File.write(@path_dir, output)
  end
end
