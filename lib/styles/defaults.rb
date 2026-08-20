require "lipgloss"

module Styles
  class Defaults
    WIDTH = 44

    attr_reader :box_style,
                :title_style,
                :subtitle_style,
                :question,
                :option,
                :kanji_style,
                :jlpt_style,
                :label_style,
                :help_style

    def initialize
      load_defaults
    end

    private

    def load_defaults
      @box_style = Lipgloss::Style.new
        .border(:rounded)
        .padding(1, 2)
        .width(40)

      @title_style = Lipgloss::Style.new
        .bold(true)
        .align(:left)

      @subtitle_style = Lipgloss::Style.new
        .faint(true)

      @question = Lipgloss::Style.new
        .bold(true)

      @option = Lipgloss::Style.new
        .faint(true)

      @kanji_style = Lipgloss::Style.new
        .bold(true)
        .align(:center)
        .width(WIDTH)

      @jlpt_style = Lipgloss::Style.new
        .faint(true)
        .align(:center)
        .width(WIDTH)

      @label_style = Lipgloss::Style.new
        .bold(true)

      @help_style = Lipgloss::Style.new
        .faint(true)
    end
  end
end