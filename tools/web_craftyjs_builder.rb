class WebCraftyJsBuilder < Builder
  WEBRUBY_FILES = { :debug => 'lib/webruby-debug.js', :release => 'lib/webruby-release.js' }
  HTML_TEMPLATE = 'template.html'
  OUTPUT_FILE = 'index.html'
  CRAFTY_LIB = 'lib/crafty-min.js'
  SOURCE_PLACEHOLDER = 'puts \'Put your code in .rb files, not here\''
  WEBRUBY_PLACEHOLDER = 'src="lib/webruby.js"'
  TARGET = 'web-craftyjs'

  def initialize(args)
    @source_folder = args[:source_folder]
    @output_folder = args[:output_folder]
    @content_folder = args[:content_folder]
    @mode = args[:mode]

    raise "Can't build in '#{@mode}' mode" if WEBRUBY_FILES[@mode.to_sym].nil?
		ensure_build_files_exist
    ensure_source_placeholder_exists
  end

  def build(code)
    # Substitute code into the template
    template_with_code = File.read("#{@source_folder}/#{HTML_TEMPLATE}").sub(SOURCE_PLACEHOLDER, code)

    # Specify debug/release version of webruby
    template_with_code = template_with_code.sub(WEBRUBY_PLACEHOLDER, WEBRUBY_PLACEHOLDER.sub('.js', "-#{@mode}.js"))

    # Start writing out files. This is always a "clean" build.
    FileUtils.rm_rf @output_folder
    FileUtils.mkdir_p @output_folder

    # Copy content
    FileUtils.cp_r CONTENT_FOLDER, "#{@output_folder}"

    # Copy main code blob
    File.open("#{@output_folder}/#{OUTPUT_FILE}", 'w') { |f|
      f.write(template_with_code)
    }
    FileUtils.cp_r("#{@source_folder}/lib", "#{@output_folder}/lib")

    # Keep one of: webruby-debug or webruby-release
    delete = @mode == 'debug' ? WEBRUBY_FILES[:release] : WEBRUBY_FILES[:debug]
    delete = "#{@output_folder}/#{delete}"
    FileUtils.rm_f delete
  end

  private

  # Make sure our build files exist on disk
  def ensure_build_files_exist
    ensure_file_exists("#{@source_folder}/#{HTML_TEMPLATE}")
    ensure_file_exists("#{@source_folder}/#{CRAFTY_LIB}")
    WEBRUBY_FILES.each do |config, file|
      ensure_file_exists("#{@source_folder}/#{file}")
    end
  end

  def ensure_source_placeholder_exists
    content = File.read("#{@source_folder}/#{HTML_TEMPLATE}")
    raise "Template #{@source_folder}/#{HTML_TEMPLATE} doesn't include placeholder #{SOURCE_PLACEHOLDER}" unless content.include?(SOURCE_PLACEHOLDER)
  end
end
