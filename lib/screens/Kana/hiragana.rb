require_relative "../base"
require "set"

module Screens
  module Kana
    class Hiragana < Screens::Base

      def initialize
        super

        @selected_groups = Set.new
        @cursor = 0

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

        options = @groups.each_with_index.map do |group, index|
          selected = @selected_groups.include?(group)
          cursor = index == @cursor

          checkbox = selected ? "[x]" : "[ ]"
          pointer = cursor ? ">" : " "

          @style.option.render(
            "#{pointer} #{checkbox} #{group}"
          )
        end.join("\n")


        content = [
          header,
          "",
          @style.question.render("Choose groups"),
          options,
          "",
          @style.help_style.render(
            "[↑↓] Move   [space] Select   [enter] Start   [esc] Back"
          )
        ].join("\n")

        center_box(content)
      end

      private

      def toggle_current_group
        @group = @groups[@cursor]

        if @selected_groups.include?(@group)
          @selected_groups.delete(@group)
        else
          @selected_groups.add(@group)
        end
      end
    end
  end
end