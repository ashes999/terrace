require 'java'

Dir["libs/\*.jar"].each { |jar| require "./#{jar}"; puts "Required #{jar}" }

# Your main game class. If you change the class name, make sure you update
# libgdx_activity.rb to specify the new game name.
java_import com.badlogic.gdx.ApplicationAdapter
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication

class Game < ApplicationAdapter
  def self.launch(game_class)
		config = LwjglApplicationConfiguration.new
    LwjglApplication.new(MainGame.new, config)
	end
end
