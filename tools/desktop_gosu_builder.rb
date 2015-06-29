class DesktopGosuBuilder < Builder
  TARGET = 'desktop-gosu'

  # The snippet we look for in main.rb to know where to insert our code.
  # This is in a comment like: # File: .../main-generated.rb
  # (courtesy of mrubymix).
  RELEASE_CODE_ENTRY_POINT = 'main-generated.rb'
  OCRA_CODE = "exit if defined?(Ocra)"
  ENTRY_POINT = 'main.rb'

  def initialize(args)
    @source_folder = args[:source_folder]
    @output_folder = args[:output_folder]
    @content_folder = args[:content_folder]
    @mode = args[:mode]
    @entry_point = args[:entry_point]

    @platform = RUBY_PLATFORM =~ /mingw/ ? :windows : :linux
  end

  def build(code)
    # Start writing out files. This is always a "clean" build.
    FileUtils.rm_rf @output_folder
    FileUtils.mkdir_p @output_folder

    # Copy content
    FileUtils.cp_r CONTENT_FOLDER, "#{@output_folder}"

    code = insert_release_code(code) if @mode == 'release'
    File.open("#{@output_folder}/#{ENTRY_POINT}", 'w') { |f|
      f.write code
    }

    build_binaries if @mode == 'release'
  end

  private

  def insert_release_code(code)
    if @platform == :windows
      code = code.sub(RELEASE_CODE_ENTRY_POINT, "\n#{OCRA_CODE}\n# File: #{RELEASE_CODE_ENTRY_POINT}")
      return code
    else # @platform == :linux
      raise 'Building releases on this platform isn\'t supported yet.'
    end
  end

  def build_binaries
    puts 'Buiding executable ...'
    `ocra #{@output_folder}/#{ENTRY_POINT} --windows`
    FileUtils.mv("#{ENTRY_POINT.sub('rb', 'exe')}","#{@output_folder}/game.exe")
  end
end
