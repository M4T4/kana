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
      action, command = current_screen.update(message)

      case action
      when :quit
        [self, Bubbletea.quit]

      when Symbol
        @screen = action

        current_screen.resize(
          width: @width,
          height: @height
        )

        [self, command]

      when Hash
        @screen = action[:screen]

        current_screen.enter(
          action[:params] || {}
        )

        current_screen.resize(
          width: @width,
          height: @height
        )

        [self, command]

      else
        [self, command]
      end

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

  def debug(message)
    File.open("/tmp/nami.log", "a") do |file|
      file.puts "[#{Time.now}] #{message}"
    end
  end

end