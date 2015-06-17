class Builder
  require 'fileutils'
  require './tools/js_crafty_builder'
  
  ENTRY_POINT = 'main.rb'    
  CODE_EXCLUSIONS = ['build.rb', ENTRY_POINT ] # ENTRY_POINT is added last
  OUTPUT_DIR = 'bin'
  TARGETS = { 'js-crafty' => 'JsCraftyBuilder' }
  
  # Builds and combines all ruby files; generates final output project
	def build
    if ARGV[0].nil?
      @target = TARGETS.first[0] # key (eg. js-crafty)
    else
      @target = ARGV[0]
      raise "#{ARGV[0]} target is not supported" if @target.nil?
    end
    
    ensure_file_exists(ENTRY_POINT)    
    puts "Buidling #{@target} target ..."
    
    builder_class = Object.const_get(TARGETS[@target])
    @builder = builder_class.new
    @code = amalgamate_code_files
    build_result
	end
  
  protected
  
  # Check if a file exists and raise if it doesn't.
  def ensure_file_exists(filename)
    raise "#{filename} not found" unless File.exist?(filename)
  end
  
  private
  
  # Combine all Ruby files together.
  def amalgamate_code_files
    print 'Concatenating ruby files '
    final_code = ''
    files = Dir.glob("pearl/#{@target}/**/*.rb") + Dir.glob('src/**/*.rb') 
    
    # TODO: what order do we traverse? These are alphabetical, not even listed
    # by directory/subdirectory first. Should we build a graph of dependencies?
    # TODO: do we need to append the entry point last? Why not just leave it up to the user?
    files.each do |f|
      file_code = File.read(f)
      final_code = "#{final_code}\n#{file_code}"
      print '.'
    end
    
    # Add entry-point code lasts, since it depends on everything else
    entry_point = File.read(ENTRY_POINT)
    final_code = "#{final_code}\n#{entry_point}"
    
    puts ' done.'
    return final_code
  end
  
  # Builds the final project output, using the template and amalgamated code.
  # Also copies relevant, dependency directories.
  def build_result
    puts "Building to #{OUTPUT_DIR} ..."    
    FileUtils.rm_rf(OUTPUT_DIR) if Dir.exist?(OUTPUT_DIR)
    FileUtils.mkdir_p(OUTPUT_DIR)
    
    @builder.build(@code)
    puts "Done!"
  end
end