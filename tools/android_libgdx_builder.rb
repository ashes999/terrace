require './tools/desktop_libgdx_builder'

class AndroidLibgdxBuilder < DesktopLibgdxBuilder

  def build(code)
    super
    # copy sources into src?
    
    # Build the debug APK
    pwd = Dir.pwd
    Dir.chdir "#{@output_folder}"
    puts "Building APK. Please be patient ..."
    `rake debug >debug.txt`
    Dir.chdir pwd

    puts "APKs generated in #{@output_folder}/bin. Log file is debug.txt"
  end
end
