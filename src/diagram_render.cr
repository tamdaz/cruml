class Cruml::DiagramRender
  @code : String = "classDiagram\n"
  def initialize(@path_dir : Path); end

  def generate(
    reflected_classes : ClassArray,
    reflected_instance_vars : Array(InstanceVarsArray),
    reflected_methods : Array(MethodsArray)
  ) : Nil
    i = 0
    until i == reflected_classes.size
      class_name = reflected_classes[i].split("::")[-1]
      @code += "class #{class_name} {\n"
      reflected_instance_vars[i].each do |t|
        name = t[-2]
        type = t[-1]
        @code += "  -#{name} : #{type}\n"
      end
      reflected_methods[i].each do |t|
        scope = case t[-3]
          when :public then "+"
          when :protected then "#"
          when :private then "-"
        end
        name = t[-2]
        return_type = t[-1]
        @code += "  #{scope}#{name}() #{return_type}\n"
      end
      @code += "}\n\n"
      i += 1
    end
  end

  def save : Nil
    output = <<-HTML
    <script src="https://cdn.jsdelivr.net/npm/mermaid@11.4.1/dist/mermaid.min.js"></script>
    <style>
      * {
        font-family: "Noto Sans Mono", monospace;
      }

      body {
        width: 100vw;
        height: 100vh;
        margin: 0 auto;
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
          maxTextSize: Infinity
        });
      })
    </script>
    HTML
    File.write(@path_dir / "diagram.html", output)
  rescue File::NotFoundError
    puts "Can't create the diagram because the \"#{@path_dir}\" directory doesn't exist. Abort."
    exit 1
  end
end