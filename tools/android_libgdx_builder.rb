require './tools/libgdx_builder'

class AndroidLibgdxBuilder < LibgdxBuilder

  def build(code)
    super
    
    # Build the debug APK
    pwd = Dir.pwd
    Dir.chdir "#{@output_folder}"
    puts "Building APK. Please be patient ..."
    `rake debug >debug.txt`
    Dir.chdir pwd

    puts "APKs generated in #{@output_folder}/bin. Log file is debug.txt"
  end
end
