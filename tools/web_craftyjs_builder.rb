require 'opal'

class WebCraftyJsBuilder < Builder
  INDEX_HTML = 'index.html'
  OUTPUT_FILE = 'main.js'
  REQUIRED_FILES = [INDEX_HTML, 'lib/crafty-min-0.6.3-dev.js', 'lib/opal-0.8.0.min.js', 'lib/native-0.8.0.min.js']
  TARGET = 'web-craftyjs'

  def initialize(args)
    @source_folder = args[:source_folder]
    @output_folder = args[:output_folder]
    @content_folder = args[:content_folder]
    @template_folder = args[:template_folder]
    @mode = args[:mode]

		ensure_build_files_exist
  end

  def build(code)
    # Start writing out files. This is always a "clean" build.
    FileUtils.rm_rf @output_folder
    FileUtils.mkdir_p @output_folder

    # Copy content
    FileUtils.cp_r @content_folder, @output_folder
    FileUtils.cp "#{@template_folder}/#{INDEX_HTML}", @output_folder

    # Build with opal
    js_code = Opal.compile(code)

    # Write main code file
    File.open("#{@output_folder}/#{OUTPUT_FILE}", 'w') { |f|
      f.write(js_code)
    }
    FileUtils.cp_r("#{@template_folder}/lib", "#{@output_folder}/lib")
  end

  private

  # Make sure our build files exist on disk
  def ensure_build_files_exist
    REQUIRED_FILES.each do |r|
      ensure_file_exists("#{@template_folder}/#{r}")
    end
  end
end
