require_relative "base"

module Screens
  class Katakana < Base 

    def update(message)
    end

    def render
      header = [
        @style.title_style.render("NAMI"),
        @style.subtitle_style.render("Learn the Japanese syllabaries")
      ].join("\n")

      options = [
        @style.question.render("Check the groups you want to practice"),
        @style.option.render("1. Gojūon ひらがな"),
        @style.option.render("2. Youon カタカナ"),
        @style.option.render("2. Sokuon カタカナ"),
        @style.option.render("2. Tokushuon カタカナ"),
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