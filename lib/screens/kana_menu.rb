require_relative "base"

module Screens
  class KanaMenu < Base 

    def update(message)
      case message.to_s
      when "1"
        :Hiragana

      when "2"
        :Katakana

      when "q", "ctrl+c"
        :quit

      else
        nil
      end
    end

    def render
      header = [
        @style.title_style.render("NAMI"),
        @style.subtitle_style.render("Learn the Japanese syllabaries")
      ].join("\n")

      options = [
        @style.question.render("Select a writing system"),
        @style.option.render("1. Hiragana ひらがな"),
        @style.option.render("2. Katakana カタカナ")
      ].join("\n")


      content = [
        header, 
        "",
        options,
        "",
      ].join("\n")

      center_box(content)
    end
  end
end