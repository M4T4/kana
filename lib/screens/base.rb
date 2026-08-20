require "lipgloss"
require_relative "../styles/defaults"

module Screens
  class Base 

    def initialize()
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
      content << "\n"
      content << help_options

      box = @style.box_style.render(content)

      Lipgloss.place(
        @width,
        @height,
        :center,
        :center,
        box
      )
    end

  end
end