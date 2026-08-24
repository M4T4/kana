# lib/app.rb

require "yaml"
require "bubbletea"
require "lipgloss"

require_relative "kanji"

# Set of screens for menu navigation.
require_relative "screens/main_menu"
require_relative "screens/kana_menu"
require_relative "screens/Kana/hiragana"
require_relative "screens/Kana/katakana"
require_relative "screens/Kana/study"
require_relative "screens/kanji"

class App
  include Bubbletea::Model

  WIDTH = 60

  def initialize
    @width = 0
    @height = 0
    @screen = :main_menu

    @screens = {
      main_menu: Screens::MainMenu.new,
      kana_menu: Screens::KanaMenu.new,
      hiragana: Screens::Kana::Hiragana.new,
      katakana: Screens::Kana::Katakana.new,
      kana_study: Screens::Kana::Study.new,
    }
  end

  def init
    [self, nil]
  end

  def update(message)
    case message
    when Bubbletea::WindowSizeMessage
      @width = message.width
      @height = message.height

      current_screen.resize(
        width: @width,
        height: @height
      )

      [self, nil]

    when Bubbletea::KeyMessage
      result = current_screen.update(message)

      handle_screen_result(result)
    else
      [self, nil]
    end
  end

  def view
    current_screen.render
  end

  private
  
  def current_screen
    @screens[@screen]
  end

  def handle_screen_result(result)
    case result
    when :quit
      [self, Bubbletea.quit]

    when Symbol
      @screen = result

      current_screen.resize(
        width: @width,
        height: @height
      )
      [self, nil]

    when Hash
      # debug("navigating #{@screen} -> #{result[:screen]}")
      # debug("params=#{result[:params].inspect}")
      
      @screen = result[:screen]

      current_screen.enter(result[:params])

      current_screen.resize(
        width: @width,
        height: @height
      )
      [self, nil]

    else
      [self, nil]
    end
  end

  def debug(message)
    File.open("/tmp/nami.log", "a") do |file|
      file.puts "[#{Time.now}] #{message}"
    end
  end

end