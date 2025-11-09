require "yaml"
require "tallboy"
require "option_parser"
require "./../transformer"
require "./../renders/diagram_render"
require "./../renders/config"
require "./runner"

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

  parser.on "-v", "--version", "Show the version" do
    puts "Cruml (version #{Cruml::VERSION})"
    exit 0
  end

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
  if paths = YAML.parse(file)["paths"]?
    paths.as_a.each do |path|
      if File.file?(path.as_s) && path.as_s.ends_with?(".cr")
        files << path.as_s
      end

      if File.directory?(path.as_s)
        files |= Dir.glob("#{path.as_s}/**/*.cr")
      end
    end
  end
end

if files.size == 0
  puts "No crystal files are present in the path, please retry.".colorize(:red)
  exit 1
end

if Cruml::Renders::Config.verbose? == true
  # ameba:disable Lint/UselessAssign
  processed_files = 0
end

Cruml::Runner.new(files, output_dir, Cruml::Renders::Config.verbose?).run
