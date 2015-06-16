class Builder
  require 'fileutils'
  
  # The code 
  ENTRY_POINT = 'main.rb'
  HTML_TEMPLATE = 'template.html'
  WEBRUBY_FILES = { :debug => 'lib/webruby-debug.js', :release => 'lib/webruby-release.js' }
  CODE_EXCLUSIONS = ['build.rb' ] 
  OUTPUT_DIR = 'bin'
  OUTPUT_FILE = 'index.html'
  DIRECTORY_EXCLUSIONS = [OUTPUT_DIR]
  SOURCE_PLACEHOLDER = 'puts \'Put your code in .rb files, not here\''
  
  # Builds and combines all ruby files; generates final output HTML/project
	def build
    mode = ARGV[0] || "debug"
    raise "Can't build in '#{mode}' mode" if WEBRUBY_FILES[mode.to_sym].nil?
    mode = mode.to_sym
    puts "Buidling in #{mode} mode ..."
		ensure_build_files_exist
    ensure_source_placeholder_exists
    code = amalgamate_code_files
    build_result(code, mode)
	end
  
  private
  
  # Make sure our build files exist on disk
  def ensure_build_files_exist
    ensure_file_exists(ENTRY_POINT)
    ensure_file_exists(HTML_TEMPLATE)
    WEBRUBY_FILES.each do |config, file|
      ensure_file_exists(file)
    end
  end
  
  # Check if a file exists and raise if it doesn't.
  def ensure_file_exists(filename)
    raise "#{filename} not found" unless File.exist?(filename)
  end
  
  def ensure_source_placeholder_exists
    content = File.read(HTML_TEMPLATE)
    raise "Template #{HTML_TEMPLATE} doesn't include placeholder #{SOURCE_PLACEHOLDER}" unless content.include?(SOURCE_PLACEHOLDER)
  end
  
  # Combine all Ruby files together; append the ENTRY_POINT last.
  def amalgamate_code_files
    final_code = ''
    files = Dir.glob('**/*.rb')
    
    # TODO: what order do we traverse? These are alphabetical, not even listed
    # by directory/subdirectory first. Should we build a graph of dependencies?
    # TODO: do we need to append the entry point last? Why not just leave it up to the user?
    files.each do |f|
      next if CODE_EXCLUSIONS.include?(f)
      file_code = File.read(f)
      final_code = "#{final_code}#{file_code}"
      puts "Processed #{f}"
    end
    
    return final_code
  end
  
  # Builds the final project output, using the template and amalgamated code.
  # Also copies relevant, dependency directories.
  def build_result(code, mode)
    # TODO: incremental build?
    
    puts "Building to #{OUTPUT_DIR} ..."    
    FileUtils.rm_rf(OUTPUT_DIR) if Dir.exist?(OUTPUT_DIR)
    FileUtils.mkdir_p(OUTPUT_DIR)
    
    template_with_code = File.read(HTML_TEMPLATE).sub(SOURCE_PLACEHOLDER, code)
    File.open("#{OUTPUT_DIR}/#{OUTPUT_FILE}", 'w') { |f|
      f.write(template_with_code)
    }
    puts "Wrote HTML and code to #{OUTPUT_DIR}/#{HTML_TEMPLATE}"
    
    directories = Dir.glob('**/*/')    
    directories.each do |d|
      d = d[0, d.rindex('/')] # remove trailing slash      
      if DIRECTORY_EXCLUSIONS.include?(d)
        puts "Skipping #{d}"
        next
      end      
      FileUtils.cp_r(d, "#{OUTPUT_DIR}/#{d}")
      puts "Copied #{d} directory"
    end
    
    # Keep one of: webruby-debug or webruby-release
    delete = mode == :debug ? WEBRUBY_FILES[:release] : WEBRUBY_FILES[:debug]
    delete = "#{OUTPUT_DIR}/#{delete}"
    FileUtils.rm_f delete
    puts "DELETED #{delete}"
    
    puts "Done!"
  end
end

Builder.new.build