require './tools/libgdx_builder'
SRC_DIR = 'src'

class DesktopLibgdxBuilder < LibgdxBuilder
  def build(code)
    super(code)
    move_contents "#{@output_folder}/#{CONTENT_FOLDER}", @output_folder
  end

  private

  # Moves contents from the src directory to the dest directory. This is like
  # when we want to move C:\tmp\src\*.rb to C:\bin, without putting it in "C:\bin\src"
  def move_contents(src, dest)
    FileUtils::cp_r "#{src}/.", dest
    FileUtils::rm_rf src
  end
end
