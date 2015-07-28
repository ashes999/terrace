class Builder
  require 'fileutils'
  require './tools/web_craftyjs_builder'
  require './tools/desktop_gosu_builder'
  require './tools/android_libgdx_builder'

  # Folder to copy. Contains all the content (images, audio, etc.)
  CONTENT_FOLDER = 'content'

  # File that contains our main / entry-point, to start our game
  ENTRY_POINT = 'main.rb'

  # When copying code, exclude these files.
  CODE_EXCLUSIONS = ['build.rb', ENTRY_POINT ] # ENTRY_POINT is added last

  # Location of built/generated output/binaries
  OUTPUT_DIR = 'bin'

  # Supported targets
  TARGETS = {
    'web-craftyjs' => 'WebCraftyJsBuilder',
    'desktop-gosu' => 'DesktopGosuBuilder',
    'android-libgdx' => 'AndroidLibgdxBuilder'
  }

  # Location of target-specific source
  TARGETS_FOLDER = 'lib'

  # Location of templates specific to platforms (eg. web, android)
  TEMPLATE_FOLDER = 'template'

  # Path to mrubymix binaries
  MRUBYMIX = '3rdparty/mrubymix/bin/mrubymix'

  # Look for this line in our entry-point. Swap TARGET with our target.
  # This causes us to load target-specific code.
  TERRACE_TARGET_REQUIRE = 'require ./lib/TARGET/terrace.rb'

  # mrubymix requires a "require" statement at the top-level. To solve this,
  # we use one require for the common code, and a placeholder statement
  # (see TERRACE_TARGET_REQUIRE). At runtime, we plug in the target name,
  # thus causing it to require the target-specific files.  This is the name
  # of the temporary file we feed in, which has the swapped-in target require.
  GENERATED_MAIN = 'main-generated.rb'

  # Builds and combines all ruby files; generates final output project
	def build
    if ARGV[0].nil?
      puts "Please specify a target to build. Valid targets are: #{TARGETS.keys}"
      return
    else
      @target = ARGV[0]
      raise "#{ARGV[0]} is not a valid target. Valid targets are: #{TARGETS.keys}" if !TARGETS.has_key?(@target)
    end

    mode = ARGV[1] == 'release' ? 'release' : 'debug'

    ensure_file_exists(ENTRY_POINT)
    if !File.read(ENTRY_POINT).include?(TERRACE_TARGET_REQUIRE)
      raise "#{ENTRY_POINT} is missing a line to require the terrace target: #{TERRACE_TARGET_REQUIRE}"
    end

    puts "Building #{@target} target in #{mode} mode ..."

    builder_class = Object.const_get(TARGETS[@target])
    @builder = builder_class.new({
      :source_folder => "#{TARGETS_FOLDER}/#{@target}",
      :output_folder => "#{OUTPUT_DIR}/#{@target}",
      :content_folder => CONTENT_FOLDER,
      :mode => mode,
      :template_folder => "#{TEMPLATE_FOLDER}/#{@target}"
    })

    amalgamate_code_files
    build_result
	end

  protected

  # Check if a file exists and raise if it doesn't.
  def ensure_file_exists(filename)
    raise "#{filename} not found" unless File.exist?(filename)
  end

  private

  # Combine all Ruby files together. Using mrubymix.
  def amalgamate_code_files

    print 'Concatenating ruby files '

    entry_point = File.read(ENTRY_POINT)
    # Put a "require" statement with our target in it
    modified_entry_point = entry_point.sub(TERRACE_TARGET_REQUIRE, TERRACE_TARGET_REQUIRE.sub('/TARGET/', "/#{@target}/"))

    # Swap in the "require" line with the correct target
    File.open(GENERATED_MAIN, 'w') { |f|
      f.write(modified_entry_point)
    }

    FileUtils.rm_f "#{OUTPUT_DIR}/#{ENTRY_POINT}"
    FileUtils.mkdir_p "#{OUTPUT_DIR}"

    `ruby #{MRUBYMIX} #{GENERATED_MAIN} #{OUTPUT_DIR}/#{ENTRY_POINT}`
    FileUtils.mv(GENERATED_MAIN, "#{OUTPUT_DIR}/#{GENERATED_MAIN}")

    puts ' done.'
  end

  # Builds the final project output, using the template and amalgamated code.
  # Also copies relevant, dependency directories.
  def build_result
    puts "Building combined .rb file to #{OUTPUT_DIR} ..."
    code = File.read "#{OUTPUT_DIR}/#{ENTRY_POINT}"
    @builder.build(code)
    FileUtils.rm "#{OUTPUT_DIR}/#{ENTRY_POINT}"
    puts "Done!"
  end
end
