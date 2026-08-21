require_relative "../base"
require "set"

module Screens
  module Kana
    class Study < Screens::Base

      def initialize(selected_groups)
        super

        @selected_groups = Set.new

        @groups = [
          "Gojūon ひらがな",
          "Yōon きゃきゅきょ",
          "Sokuon っ",
          "Tokushūon ん",
          "Dakuten / Handakuten がざだばぱ"
        ]
      end

      def update(message)
        case message.to_s
        when "up", "k"
          @cursor = (@cursor - 1) % @groups.size

        when "down", "j"
          @cursor = (@cursor + 1) % @groups.size

        when "space"
          toggle_current_group

        when "enter"
          return :kana_study unless @selected_groups.empty?

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


        content = [
          header,
          "",
          @style.question.render("heheheS"),
          "",
          @style.help_style.render(
            "[↑↓] Move   [space] Select   [enter] Start   [esc] Back"
          )
        ].join("\n")

        center_box(content)
      end

    end
  end
end