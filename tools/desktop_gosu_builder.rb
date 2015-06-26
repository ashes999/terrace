class DesktopGosuBuilder < Builder
  TARGET = 'desktop-gosu'

  def initialize(args)
    @source_folder = args[:source_folder]
    @output_folder = args[:output_folder]
    @content_folder = args[:content_folder]
    @mode = args[:mode]
  end

  def build(code)
    # Start writing out files. This is always a "clean" build.
    FileUtils.rm_rf @output_folder
    FileUtils.mkdir_p @output_folder

    # Copy content
    FileUtils.cp_r CONTENT_FOLDER, "#{@output_folder}"
    File.open("#{@output_folder}/main.rb", 'w') { |f|
      f.write code
    }
  end
end
