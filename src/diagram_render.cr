class Cruml::DiagramRender
  @code : String = "classDiagram\ndirection BT\n"

  def initialize(@path_dir : Path); end

  def generate(class_list : Cruml::ClassList) : Nil
    class_list.classes.each do |class_info|
      add_inherit_class(class_info.inherit_classes)
      add_class(class_info)
    end
    set_diagram_colors
  end

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

  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    namespace = class_info.name.split("::")[0..-2].join("")
    short_class_name = class_info.name.split("::")[-1]

    case class_info.type
    when :interface then @code += "&lt;&lt;interface&gt;&gt; #{short_class_name}\n"
    when :abstract  then @code += "&lt;&lt;abstract&gt;&gt; #{short_class_name}\n"
    end

    @code += "namespace #{namespace} {\n"
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
        @code += "    +#{method.name}() #{method.return_type}\n"
      end
    end

    @code += "  }\n" # end class
    @code += "}\n"   # end namespace
  end

  private def set_diagram_colors : Nil
    @code += "classDef default fill:#2e1065,color:white\n"
    @code += "classDef interface fill:#365314,color:white"
    @code += "namespaceDef default fill:#ffffff"
  end

  def save : Nil
    output = <<-HTML
    <head>
      <title>UML Class Diagram : #{::CRUML_FILTER_PREFIX}</title>
    </head>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.min.js"></script>
    <script src='https://unpkg.com/panzoom@8.7.3/dist/panzoom.min.js'></script>
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Roboto+Mono:ital,wght@0,100..700;1,100..700&display=swap');
      * {
        font-family: "Roboto Mono", monospace;
      }

      body {
        width: 100vw;
        height: 100vh;
        margin: 0 auto;
        background-color: #212121;
        overflow: hidden;
      }

      .mermaid {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
      }
    </style>
    <!--
      UML code will be set here. After that,
      a class diagram will be displayed on the web browser.
    -->
    <div class="mermaid">
      #{@code}
    </div>
    <script>
      /**
       * Load the UML class diagram once the page is loaded.
       */
      window.addEventListener("DOMContentLoaded", () => {
        mermaid.initialize({
          startOnLoad: true,
          maxTextSize: Infinity,
          theme: "dark"
        });
        panzoom(document.querySelector(".mermaid"), {
          bounds: true,
          boundsPadding: 0.6,
          maxZoom: 2.5,
          minZoom: 0.1
        });
      })
    </script>
    HTML
    Dir.mkdir(@path_dir) unless Dir.exists?(@path_dir)
    File.write(@path_dir / "diagram.html", output)
  end
end
