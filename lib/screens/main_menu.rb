require "lipgloss"

module Screens
  class MainMenu 
    WIDTH = 44

    def initialize()

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

    def update(message)
      case message.to_s
      when "1"
        :kana_menu

      when "2"
        :kanji

      when "3"
        :vocabulary

      when "q", "ctrl+c"
        :quit

      else
        nil
      end
    end

    def render
      header = [
        @title_style.render("NAMI"),
        @subtitle_style.render("Japanese Writting System Trainer")
      ].join("\n")

      starting_options = [
        @question.render("Select an option"),
        @option.render("1. Kana あ"),
        @option.render("2. Kanji 日"),
        @option.render("3. Vocabulary 語彙"),
      ]

      help = @help_style.render(
        "[i] Info   [h] help   [q] Quit"
      )

      content = [
        header, 
        "",
        starting_options,
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

    def resize(width:, height:)
      @width = width
      @height = height
    end
  end
end