require 'java'

Dir["../libs/\*.jar"].each { |jar| require jar; puts "Required #{jar}" }
#require "libs/gdx-1.6.3.jar"
#require "libs/gdx-box2d-1.6.3.jar"
#require "libs/gdx-backend-lwjgl-1.6.3.jar"
#require "libs/gdx-platform-1.6.3-natives-desktop.jar"
#require "libs/gdx-box2d-platform-1.6.3-natives-desktop.jar"

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
java_import com.badlogic.gdx.ApplicationAdapter;
java_import com.badlogic.gdx.Gdx;
java_import com.badlogic.gdx.graphics.GL20;
java_import com.badlogic.gdx.graphics.Texture;
java_import com.badlogic.gdx.graphics.g2d.SpriteBatch;

class TestGame < ApplicationAdapter

  def create
    @batch = SpriteBatch.new
    @img = Texture.new("../assets/badlogic.jpg")
  end

  def render
    Gdx.gl.glClearColor(1, 0, 0, 1)
    Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)
    @batch.begin
    @batch.draw(@img, 0, 0)
    @batch.end
  end
end

config = LwjglApplicationConfiguration.new
LwjglApplication.new(TestGame.new, config)
