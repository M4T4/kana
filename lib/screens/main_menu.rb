require_relative "base"

module Screens
  class MainMenu < Base

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
        @style.title_style.render("NAMI"),
        @style.subtitle_style.render("Japanese Writting System Trainer")
      ].join("\n")

      starting_options = [
        @style.question.render("Select an option"),
        @style.option.render("1. Kana あ"),
        @style.option.render("2. Kanji 日"),
        @style.option.render("3. Vocabulary 語彙"),
      ]

      content = [
        header, 
        "",
        starting_options,
        "",
        help_options,
      ].join("\n")

      center_box(content)
    end
  end
end