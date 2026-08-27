require "bundler/setup"
require "bubbletea"
require "lipgloss"
require "bubbles"
require_relative "../styles/defaults"

module Screens
  class Base 
    GROUP_LABELS = {
        "gojuon" => "Gojūon",
        "dakuten" => "Dakuten",
        "yoon" => "Yōon",
        "sokuon" => "Sokuon",
        "tokushuon" => "Tokushūon",
        "handakuten" => "Handakuten"
      }

    def initialize
      @width = 0
      @height = 0
      @style = Styles::Defaults.new()
    end

    def resize(width:, height:)
      @width = width
      @height = height
    end

    def help_options
      @style.help_style.render(
        "[i] Info   [h] help   [q] Quit"
      )
    end

    def center_box(content)
      box = @style.box_style.render(content)

      Lipgloss.place(
        @width,
        @height,
        :center,
        :center,
        box
      )
    end

    def debug(message)
      File.open("/tmp/nami.log", "a") do |file|
        file.puts "[#{Time.now}] #{message}"
      end
    end

  end
end