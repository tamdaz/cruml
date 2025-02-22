require "option_parser"
require "./transformer"
require "./renders/diagram_render"
require "./renders/config"

files = [] of String
verbose = false

OptionParser.parse do |parser|
  parser.banner = "Usage : cruml [subcommand] [arguments] -- [options]"

  parser.on "generate", "Generate the class diagram" do
    parser.banner = "Usage : cruml generate [arguments] -- [options]"

    parser.on "--verbose", "Enable verbose" { verbose = true }

    parser.on "--dark-mode", "Set to dark mode" do
      Cruml::Renders::Config.theme = :dark
    end

    parser.on "--no-color", "Disable color output" do
      Cruml::Renders::Config.no_color = true
    end

    parser.on "--path=PATH", "Path to specify" do |path|
      files << path if File.file?(path) && path.ends_with?(".cr")
      files |= Dir.glob("#{path}/**/*.cr") if File.directory?(path)
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

if files.size == 0
  puts "No crystal files are present in the path, please retry.".colorize(:red)
  exit 1
end

files.each do |file|
  ast = Crystal::Parser.parse(File.read(file))
  tx = Cruml::Transformer.new
  ast.transform(tx)
end

Cruml::ClassList.verify_instance_var_duplication

diagram = Cruml::Renders::DiagramRender.new("out/diagram.html")
diagram.generate
diagram.save
