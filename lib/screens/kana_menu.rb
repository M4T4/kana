require "lipgloss"

module Screens
  class KanaMenu 
    def initialize
      @box = Lipgloss::Style.new
        .border(:rounded)
        .padding(1, 2)
        .width(40)
    end

    def render
      header = [
        @title_style.render("KANA"),
        @subtitle_style.render("Learn the Japanese syllabaries")
      ].join("\n")

      options = [
        @question.render("Select a writing system"),
        @option.render("1. Hiragana ひらがな"),
        @option.render("2. Katakana カタカナ")
      ].join("\n")

      help = @help_style.render(
        "[esc] Back   [q] Quit"
      )

      content = [
        header, 
        "",
        options,
        "",
        help
      ].join("\n")

      box = @box_style.render(content)

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