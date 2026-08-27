require_relative "../base"
require_relative "../../kana"
require "set"
require "yaml"


module Screens
  module Kana
    class Study < Screens::Base

      def initialize
        super
        @selected_groups = Set.new
        @syllabary = nil
        @index = 0

        @input = create_input("Enter:", " ")
        @submitted = false

        @label_style = Lipgloss::Style.new.foreground("99")
        

        @kana_style = Lipgloss::Style.new
          .bold(true)
          .align(:center)
          .width(44)

        @test = Lipgloss::Style.new
          .bold(true)
          .align(:right)
          .width(44)
      end

      def update(message)
        case message.to_s
        when "enter"
          check_answer

          return [nil, nil]

        when "esc"
          return [:kana_menu, nil]

        when "ctrl+c"
          return [:quit, nil]
        end

        @input, command = @input.update(message)

        [nil, command]
      end

      def render
        @kana = @kanas[@index]

        header = [
          @style.title_style.render("NAMI"),
          session_info
        ].join("\n")

        input_section = "#{@label_style.render("Enter:")} #{@input.view}"

        content = [
          header,
          "",
          "Type romaji form for #{@syllabary} character:",
          "",
          @kana_style.render(@kana.character),
          "",
          input_section,
          "",
          "[esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @selected_groups = params[:selected_groups] || []
        @syllabary = params[:syllabary] || []
        @kanas = load_kana

        @index = 0
        @input.focus
      end

      private

      def load_kana
        path = File.expand_path("../../../data/kana.yml", __dir__)
        data = YAML.load_file(path)

        filtered_data = data[@selected_groups.to_a.first]["ka"]
        
        filtered_data.map do |data|
          ::Kana.new(
            family: "gojuon",
            group: "ka",
            syllabary: @syllabary,
            character: data[@syllabary],
            romaji: data["roumaji"]
          )
        end
      end

      def check_answer
        @index = @index + 1
        debug("input=#{@input}")
      end

      def create_input(_name, placeholder, password: false)
        input = Bubbles::TextInput.new
        input.prompt = ""
        input.placeholder = placeholder
        input.echo_mode = password ? :password : :normal

        input
      end

      def session_info
        title = @style.subtitle_style.render("Study Session")
        progress = @style.subtitle_style.render("1/5")

        spacing = 40 - "Study Session".length - "1/5".length

        "#{title}#{" " * spacing}#{progress}"
      end
    end
  end
end