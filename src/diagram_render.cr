class Cruml::DiagramRender
  @code : String = "classDiagram\n"

  def initialize(@path_dir : Path); end

  def generate(
    reflected_classes : ClassArray,
    reflected_link_subclasses : LinkSubClassArray,
    reflected_instance_vars : Array(InstanceVarsArray),
    reflected_methods : Array(MethodsArray)
  ) : Nil
    add_links(reflected_link_subclasses)

    i = 0
    until i == reflected_classes.size
      add_classes(reflected_classes, i)
      add_instance_vars(reflected_instance_vars, i)

      unless reflected_methods.size == 0
        reflected_methods[i].each do |method|
          scope = case method[-3]
                  when :public    then "+"
                  when :protected then "#"
                  when :private   then "-"
                  end
          name = method[-2]
          return_type = method[-1]
          @code += "  #{scope}#{name}() #{return_type}\n"
        end
      end

      @code += "}\n\n"
      i += 1
    end

    set_diagram_colors
  end

  private def add_classes(reflected_classes : ClassArray, i : Int32) : Nil
    class_name = reflected_classes[i][0].split("::")[-1]

    case reflected_classes[i][1]
    when :interface
      @code += "&lt;&lt;interface&gt;&gt; #{class_name}\n"
      @code += "class #{class_name}:::interface {\n"
    when :abstract
      @code += "&lt;&lt;abstract&gt;&gt; #{class_name}\n"
      @code += "class #{class_name} {\n"
    when :class
      @code += "class #{class_name} {\n"
    end
  end

  private def add_links(reflected_link_subclasses : LinkSubClassArray) : Nil
    reflected_link_subclasses.each do |class_name, subclass_name, class_type|
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

  private def add_instance_vars(reflected_instance_vars : Array(InstanceVarsArray), i : Int32) : Nil
    unless reflected_instance_vars.size == 0
      reflected_instance_vars[i].each do |instance_var|
        name = instance_var[-2]
        type = instance_var[-1]
        @code += "  -#{name} : #{type}\n"
      end
    end
  end

  private def set_diagram_colors : Nil
    @code += "classDef default fill:#2e1065,color:white\n"
    @code += "classDef interface fill:#365314,color:white"
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
