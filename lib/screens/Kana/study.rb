require_relative "../base"
require_relative "../../kana"
require "set"
require "yaml"
require "json"


module Screens
  module Kana
    class Study < Screens::Base

      def initialize
        super
        @selected_groups = Set.new
        @syllabary = nil
        @index = 0
        @results = []

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
          if @index == @kanas.size - 1
            check_answer
            complete_test

            return [
              {
                screen: :kana_results,
                params: {
                  results: @results
                }
              },
              nil
            ]
          else
            check_answer

            return [nil, nil]
          end


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

        @results << {
          study_data: {
            started_at: Time.now,
            syllabary: @syllabary,
            groups: @selected_groups,
            correct_answers: 0,
          }
        }
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
            romaji: data["romaji"]
          )
        end
      end

      def check_answer
        @index += 1
        debug("input=#{@input.value}")
        debug("kana=#{@kana.romaji}")

        if @input.value == @kana.romaji
          result_item = {
            character: @kana.character,
            correct_answer: @kana.romaji,
            answer: @input.value,
            correct: true
          }
        else
          result_item = {
            character: @kana.character,
            correct_answer: @kana.romaji,
            answer: @input.value,
            correct: false
          }

        end

        @input.value = ""
        @results << result_item
      end

      def complete_test
        file_path = 'results/study.json'

        if File.exist?(file_path) && !File.read(file_path).empty?
          data = JSON.parse(File.read(file_path))
        else
          data = []
        end
        
        calculate_timstamps
        
        data << @results

        File.write(file_path, JSON.pretty_generate(data))
      end

      def calculate_timstamps
        study_data = @results[0][:study_data]
        @results[0][:study_data][:ended_at] = Time.now
        @results[0][:study_data][:duration] = study_data[:ended_at] - study_data[:started_at]
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