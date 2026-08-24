require_relative "../base"
require "set"

module Screens
  module Kana
    class Study < Screens::Base

      def initialize
        super
        @selected_groups = Set.new
      end

      def update(message)
        case message.to_s


        when "enter"
          next_character

        when "q", "ctrl+c"
          :quit

        else
          nil
        end
      end

      def render
        content = [
          "HIRAGANA",
          "",
          "Selected groups:",
          @selected_groups.join(", "),
          "",
          "[esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @selected_groups = params[:selected_groups] || []
      end

    end
  end
end