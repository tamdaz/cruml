require "ecr"

# Consists of generating a class diagram.
# See https://mermaid.js.org/syntax/classDiagram.html
class Cruml::Renders::DiagramRender
  @code = String::Builder.new("classDiagram\n")

  def initialize(@path_dir : String)
    Cruml::ModuleList.modules.each do |mod|
      @code << "class #{mod.name}:::module {\n"
      @code << "&lt;&lt;module&gt;&gt;\n"

      mod.instance_vars.each do |instance_var|
        name, type = instance_var[-2], instance_var[-1]
        @code << "    -#{name} : #{type}\n"
      end

      mod.methods.each do |method|
        literal_scope = case method.scope
                        when :public    then '+'
                        when :protected then '#'
                        when :private   then '-'
                        else                 '+'
                        end

        @code << "    #{literal_scope}#{method.name}(#{method.generate_args}) "
        @code << " : " if method.return_type =~ /\(.*\)/
        @code << "#{method.return_type}\n"
      end
      @code << "}\n" # end module
    end

    Cruml::ClassList.group_by_namespaces.each do |klass_group|
      # Add a relationship before creating a namespace.
      klass_group[1].each { |klass| add_inherit_class(klass.inherit_classes) }

      # @code << "namespace #{klass_group[0]} {\n" # begin namespace
      klass_group[1].each do |class_info|
        add_class(class_info)
      end
      # @code << "}\n" # end namespace
    end
    set_diagram_colors
  end

  # Creates a link between the parent and child classes.
  # If the parent class type is abstract, the arrow would look like : <|..
  # If the parent class type is normal, the arrow would look like : <|--
  # See https://mermaid.js.org/syntax/classDiagram.html#defining-relationship for more info.
  private def add_inherit_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, class_type|
      case class_type
      when :abstract
        @code << "#{class_name.split("::")[-1]} <|.. #{subclass_name.split("::")[-1]}\n"
      when :class
        @code << "#{class_name.split("::")[-1]} <|-- #{subclass_name.split("::")[-1]}\n"
      end
    end
  end

  # Creates a class with a whole set of instance variables and methods.
  # See https://mermaid.js.org/syntax/classDiagram.html#class for more info.
  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    short_class_name = class_info.name.split("::")[-1]

    case class_info.type # begin class
    when :abstract
      @code << "  class #{short_class_name}:::abstract {\n"
      @code << "    &lt;&lt;abstract&gt;&gt;\n"
    when :class
      @code << "  class #{short_class_name} {\n"
    end

    unless class_info.instance_vars.size == 0
      class_info.instance_vars.each do |instance_var|
        name, type = instance_var[-2], instance_var[-1]
        @code << "    -#{name} : #{type}\n"
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

        @code << "    #{literal_scope}#{method.name}(#{method.generate_args}) "
        @code << " : " if method.return_type =~ /\(.*\)/
        @code << "#{method.return_type}\n"
      end
    end

    @code << "  }\n" # end class
  end

  # Define the style properties for the class diagram.
  # See https://mermaid.js.org/syntax/classDiagram.html#css-classes for more info.
  private def set_diagram_colors : Nil
    @code << "classDef default fill:#2e1065,color:white\n"
    @code << "classDef abstract fill:#365314,color:white\n"
    @code << "classDef module fill:#0041cc,color:white"
  end

  # Save the class diagram as a HTML file.
  def save : Nil
    output = ECR.render("src/renders/diagram.ecr")
    File.write(@path_dir, output)
  end
end
