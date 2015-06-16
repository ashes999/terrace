class JsCraftyBuilder < Builder
  WEBRUBY_FILES = { :debug => 'lib/webruby-debug.js', :release => 'lib/webruby-release.js' }
  HTML_TEMPLATE = 'template.html'
  OUTPUT_FILE = 'index.html'
  CRAFTY_LIB = 'lib/crafty-min.js'
  SOURCE_PLACEHOLDER = 'puts \'Put your code in .rb files, not here\''
  WEBRUBY_PLACEHOLDER = 'src="lib/webruby.js"'
  TARGET = 'js-crafty'
  
  def initialize
    mode = ARGV[1] || "debug"
    raise "Can't build in '#{mode}' mode" if WEBRUBY_FILES[mode.to_sym].nil?
    puts "Building in #{mode} mode"
    @mode = mode.to_sym
		ensure_build_files_exist
    ensure_source_placeholder_exists
  end
  
  def build(code)
  # Substitute code into the template
    template_with_code = File.read("pearl/#{TARGET}/#{HTML_TEMPLATE}").sub(SOURCE_PLACEHOLDER, code)
    
    # Specify debug/release version of webruby
    template_with_code = template_with_code.sub(WEBRUBY_PLACEHOLDER, WEBRUBY_PLACEHOLDER.sub('.js', "-#{@mode}.js"))
    
    File.open("#{OUTPUT_DIR}/#{OUTPUT_FILE}", 'w') { |f|
      f.write(template_with_code)
    }
    
    FileUtils.cp_r("pearl/#{TARGET}/lib", "#{OUTPUT_DIR}/lib")
    
    # Keep one of: webruby-debug or webruby-release
    delete = @mode == :debug ? WEBRUBY_FILES[:release] : WEBRUBY_FILES[:debug]
    delete = "#{OUTPUT_DIR}/#{delete}"
    FileUtils.rm_f delete
  end
  
  private
  
  # Make sure our build files exist on disk
  def ensure_build_files_exist
    ensure_file_exists("pearl/#{TARGET}/#{HTML_TEMPLATE}")
    ensure_file_exists("pearl/#{TARGET}/#{CRAFTY_LIB}")
    WEBRUBY_FILES.each do |config, file|
      ensure_file_exists("pearl/#{TARGET}/#{file}")
    end
  end
  
  def ensure_source_placeholder_exists
    content = File.read("pearl/#{TARGET}/#{HTML_TEMPLATE}")
    raise "Template pearl/#{TARGET}/#{HTML_TEMPLATE} doesn't include placeholder #{SOURCE_PLACEHOLDER}" unless content.include?(SOURCE_PLACEHOLDER)
  end
end