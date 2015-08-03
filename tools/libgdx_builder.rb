class LibgdxBuilder < Builder
  TARGET = 'desktop-libgdx'
  OUTPUT_FILE = 'src/main_game.rb'
  CONTENT_FOLDER = 'assets'
  SHARED_TEMPLATE_DIR = 'shared-libgdx'
  LIB_FOLDER = 'libs'
  
  def initialize(args)
    @source_folder = args[:source_folder]
    @output_folder = args[:output_folder]
    @content_folder = args[:content_folder]
    @template_folder = args[:template_folder]
    @mode = args[:mode]
  end

  def build(code)
    # Start writing out files. This is always a "clean" build.
    FileUtils.rm_rf @output_folder

    # Copy the whole Android template_folder
    FileUtils.cp_r("#{@template_folder}", "#{@output_folder}")

    # Copy the shared template folder
    template_root = @template_folder[0, @template_folder.rindex('/')]
    output_libs_folder = "#{@output_folder}/#{LIB_FOLDER}"
    FileUtils.mkdir_p output_libs_folder
    FileUtils.cp_r("#{template_root}/#{SHARED_TEMPLATE_DIR}/.", "#{output_libs_folder}")
    
    # Copy over the content_folder. This will be slow with big content folders.
    puts "Copying content folder ..."
    FileUtils.rm_rf "#{@output_folder}/#{CONTENT_FOLDER}"
    target_folder = "#{@output_folder}/#{CONTENT_FOLDER}"
    FileUtils.mkdir_p target_folder # forces creating of assets/content folder
    FileUtils.cp_r(@content_folder, target_folder)

    # Write main code file.
    File.open("#{@output_folder}/#{OUTPUT_FILE}", 'w') { |f|
      f.write(code)
    }
  end
end
