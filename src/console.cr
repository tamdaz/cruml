require "tallboy"
require "option_parser"
require "./transformer"
require "./renders/diagram_render"
require "./renders/config"

files = [] of String
output_dir = "out/"

OptionParser.parse do |parser|
  parser.banner = "Usage : cruml [subcommand] [arguments] -- [options]"

  parser.on "generate", "Generate the class diagram" do
    parser.banner = "Usage : cruml generate [arguments] -- [options]"

    parser.on "--verbose", "Enable verbose" do
      Cruml::Renders::Config.verbose = true
    end

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

    parser.on "--output-dir=DIR", "Directory path to save diagrams" { |dir| output_dir = dir }
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

processed_files = 0 if Cruml::Renders::Config.verbose? == true

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

measured_time_to_verify = Time.measure do
  Cruml::ClassList.verify_instance_var_duplication
end

measured_time_to_render = Time.measure do
  diagram = Cruml::Renders::DiagramRender.new("#{output_dir}/diagram.html")
  diagram.generate
  diagram.save
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
