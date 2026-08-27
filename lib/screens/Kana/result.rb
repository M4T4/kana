require_relative "../base"
require_relative "../../kana"
require "set"
require "yaml"
require "json"


module Screens
  module Kana
    class Result < Screens::Base

      def initialize
        super
        @selected_groups = Set.new
        @syllabary = nil
        @index = 0
        @results = []
      end

      def update(message)
        case message.to_s
        when "enter"

          return [nil, nil]

        when "esc"
          return [:kana_menu, nil]

        when "ctrl+c"
          return [:quit, nil]
        end

        [nil, nil]
      end

      def render
        header = [
          @style.title_style.render("NAMI"),
          "",
          "Results !!!!",
          "",
        ].join("\n")


        content = [
          header,
          "",
          "Los súper resultados: #{@results}",
          "",
          "[esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @results = params[:results]
      end

    end
  end
end


# Y luego puedes recorrerla fácilmente:

# @results.each do |result|
#   puts "#{result[:character]}: #{result[:correct] ? "✓" : "✗"}"
# end

# produciendo algo como:

# か: ✓
# き: ✗
# く: ✓
# け: ✓

# Para NAMI me gusta esta estructura porque después podrás calcular cosas como:

# correct = @results.count { |result| result[:correct] }
# incorrect = @results.count { |result| !result[:correct] }


# accuracy = correct.to_f / @results.size * 100