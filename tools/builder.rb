class Builder
  require 'fileutils'

  # Folder to copy. Contains all the content (images, audio, etc.)
  CONTENT_FOLDER = 'content'

  # File that contains our main / entry-point, to start our game
  ENTRY_POINT = 'main.rb'

  # When copying code, exclude these files.
  CODE_EXCLUSIONS = ['build.rb', ENTRY_POINT ] # ENTRY_POINT is added last

  # Location of built/generated output/binaries
  OUTPUT_DIR = 'bin'

  # Supported targets, and their builder classes
  TARGETS = {
    'web-craftyjs' => 'WebCraftyJsBuilder',
    'desktop-libgdx' => 'DesktopLibgdxBuilder',
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

  # mrubymix requires a "require" statement at the top-level, and we need to
  # combine classes from the common directory with the platform one.
  # This file is a copy of main.rb, but with the require for the TARGET folder
  # replaced with the actual command-line target (eg. web-craftyjs).
  GENERATED_MAIN = 'main-generated.rb'

  # Builds and combines all ruby files; generates final output project
	def build(target = nil, mode = nil)
    if target.nil? && ARGV[0].nil?
      puts "Please specify a target to build. Valid targets are: #{TARGETS.keys}"
      return
    else
      @target = target || ARGV[0]
      raise "#{@target} is not a valid target. Valid targets are: #{TARGETS.keys}" if !TARGETS.has_key?(@target)
    end

    mode = ARGV[1] if mode.nil?
    mode = (mode == 'release') ? 'release' : 'debug'

    ensure_file_exists(ENTRY_POINT)
    if !File.read(ENTRY_POINT).include?(TERRACE_TARGET_REQUIRE)
      raise "#{ENTRY_POINT} is missing a line to require the terrace target: #{TERRACE_TARGET_REQUIRE}"
    end

    puts "Building #{@target} target in #{mode} mode ..."
    require './tools/web_craftyjs_builder' if @target.start_with?('web')
    require './tools/desktop_libgdx_builder' if @target.start_with?('desktop')
    require './tools/android_libgdx_builder' if @target.start_with?('android')

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

    `ruby -I . #{MRUBYMIX} #{GENERATED_MAIN} #{OUTPUT_DIR}/#{ENTRY_POINT}`
    raise 'Running mrubymix failed' unless $?.success?
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
