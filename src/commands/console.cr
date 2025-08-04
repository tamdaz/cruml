require "yaml"
require "tallboy"
require "option_parser"
require "./../transformer"
require "./../renders/diagram_render"
require "./../renders/config"

# Files to process
files = [] of String

# Output directory
output_dir = "out/"

OptionParser.parse do |parser|
  parser.banner = "Usage : cruml [subcommand] [arguments] -- [options]"

  parser.on "config", "Configuration" do
    # Generate a YML config.
    parser.on "--generate", "Generate a YML config" do
      output = YAML.build do |yml|
        yml.mapping do
          yml.scalar "colors"
          yml.mapping do
            yml.scalar "light"
            yml.mapping do
              yml.scalar "classes"
              yml.scalar "#baa7e5"
              yml.scalar "abstract_classes"
              yml.scalar "#a7e5a7"
              yml.scalar "interfaces"
              yml.scalar "#e2c7a3"
              yml.scalar "modules"
              yml.scalar "#5ab3f4"
            end
            yml.scalar "dark"
            yml.mapping do
              yml.scalar "classes"
              yml.scalar "#2e1065"
              yml.scalar "abstract_classes"
              yml.scalar "#365314"
              yml.scalar "interfaces"
              yml.scalar "#af6300"
              yml.scalar "modules"
              yml.scalar "#0041cc"
            end
          end

          yml.scalar "paths"
          yml.sequence do
            yml.scalar "src/"
          end

          yml.scalar "namespaces"
          yml.mapping do
            yml.scalar "Namespace"
            yml.sequence do
              yml.scalar "ClassOne"
              yml.scalar "ClassTwo"
              yml.scalar "ClassThree"
            end
          end
        end
      end

      begin
        File.write(Dir.current + "/.cruml.yml", output)
        puts "Config is successfully generated."
        exit 0
      rescue Exception
        puts "Impossble to generate the YML config file. Please retry."
      end
    end
  end

  # `generate` argument
  parser.on "generate", "Generate the class diagram" do
    parser.banner = "Usage : cruml generate [arguments] -- [options]"

    # Verbose flag
    parser.on "--verbose", "Enable verbose" do
      Cruml::Renders::Config.verbose = true
    end

    # Dark mode flag
    parser.on "--dark-mode", "Set to dark mode" do
      Cruml::Renders::Config.theme = :dark
    end

    # No color flag
    parser.on "--no-color", "Disable color output" do
      Cruml::Renders::Config.no_color = true
    end

    # Path to specify flag
    parser.on "--path=PATH", "Path to specify" do |path|
      if File.file?(path) && path.ends_with?(".cr")
        files << path
      end

      if File.directory?(path)
        files |= Dir.glob("#{path}/**/*.cr")
      end
    end

    # Output directory flag
    parser.on "--output-dir=DIR", "Directory path to save diagrams" do |dir|
      output_dir = dir
    end
  end

  # Version flag
  parser.on "-v", "--version", "Show the version" do
    puts "Cruml (version #{Cruml::VERSION})"
    exit 0
  end

  # Help flag
  parser.on "-h", "--help", "Show this help" do
    puts parser
    exit 0
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option.".colorize(:red)
    STDERR.puts parser
    exit 1
  end
end

# Retrieve paths from the YML file config.
File.open(Dir.current + "/.cruml.yml") do |file|
  paths = YAML.parse(file)["paths"]?

  if paths
    paths.as_a.each do |path_from_yml|
      if File.file?(path_from_yml.as_s) && path_from_yml.as_s.ends_with?(".cr")
        files << path_from_yml.as_s
      end

      if File.directory?(path_from_yml.as_s)
        files |= Dir.glob("#{path_from_yml.as_s}/**/*.cr")
      end
    end
  end
end

if files.size == 0
  puts "No crystal files are present in the path, please retry.".colorize(:red)
  exit 1
end

processed_files = 0 if Cruml::Renders::Config.verbose? == true

# Time to process files.
measured_time_to_process = Time.measure do
  files.each do |file|
    ast = Crystal::Parser.parse(File.read(file))
    tx = Cruml::Transformer.new
    ast.transform(tx)

    if Cruml::Renders::Config.verbose? == true && processed_files
      processed_files += 1
    end
  end
end

# Time to verify instance variables.
measured_time_to_verify = Time.measure do
  Cruml::ClassList.verify_instance_var_duplication
end

# Time to render
measured_time_to_render = Time.measure do
  diagram = Cruml::Renders::DiagramRender.new("#{output_dir}/diagram.d2")
  diagram.generate
  diagram.save

  begin
    process = Process.run("d2", ["out/diagram.d2", "out/diagram.svg", "-c"])

    if process.exit_code != 0
      puts "Cannot render the class diagram with d2; maybe because of the syntax error."
      exit 1
    end
  rescue File::NotFoundError
    puts "d2 is not installed. Please go to https://github.com/terrastruct/d2 to install it."
    exit 1
  end
end

if Cruml::Renders::Config.verbose? == true
  table = Tallboy.table do
    header "Statistics"
    rows [
      ["Processed files", processed_files],
      ["Time to process", measured_time_to_process],
      ["Time to verify (ivars, cvars)", measured_time_to_render],
      ["Time to render", measured_time_to_verify],
      ["Global time", measured_time_to_process + measured_time_to_render + measured_time_to_verify],
    ]
  end

  puts table
else
  total_time = measured_time_to_process + measured_time_to_render + measured_time_to_verify
  if total_time.total_seconds >= 1
    puts "Diagram successfully generated in #{total_time.total_seconds.round(2)} seconds.".colorize(:green)
  else
    puts "Diagram successfully generated in #{total_time.total_milliseconds.round(2)} milliseconds.".colorize(:green)
  end
end
