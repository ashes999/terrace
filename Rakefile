require './tools/builder'
b = Builder.new

namespace :build do
  desc "Create the web version of the game (HTML5/CraftyJS)"
  task :web do
    b.build('web-craftyjs', 'debug')
  end
  
  desc "Create the desktop version of the game (JRuby/libGDX)"
  task :desktop do
    b.build('desktop-libgdx', 'debug')
  end
  
  desc "Create the Android version of the game (Ruboto/libGDX)"
  task :android do
    b.build('android-libgdx', 'debug')
  end

end

# set default task: build the web one
task :default => ['build:web'] 
