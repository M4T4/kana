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
      end

      def update(message)
        case message.to_s
        when "enter"
          check_answer
          
          if last_kana?
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
          end

          next_kana

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

        input_section = "#{@style.label_style.render("Enter:")} #{@input.view}"

        content = [
          header,
          "",
          "Type romaji form for #{@syllabary} character:",
          "",
          @style.kana_style.render(@kana.character),
          "",
          input_section,
          "",
          "[esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @session_started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @selected_groups = params[:selected_groups] || []
        @syllabary = params[:syllabary] || []
        @kanas = load_kana

        @index = 0
        @input.focus

        @results << {
          study_data: {
            started_at: Time.now,
            ended_at: 0,
            duration: 0,
            syllabary: @syllabary,
            groups: @selected_groups,
          }
        }

        start_kana_timer
      end

      private

      def last_kana?
        @index == @kanas.size - 1
      end

      def next_kana
        @index += 1
        @input.value = ""
        start_kana_timer
      end

      def start_kana_timer
        @kana_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

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
        ended_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        answer = @input.value.strip.downcase
        response_time = ended_at - @kana_time


        @results << result_item = {
          character: @kana.character,
          correct_answer: @kana.romaji,
          answer: answer,
          correct: answer == @kana.romaji,
          response_time: response_time.round(3),
        }
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
        session_ended_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        duration = session_ended_at - @session_started_at

        study_data = @results[0][:study_data]
        @results[0][:study_data][:ended_at] = Time.now
        @results[0][:study_data][:duration] = duration.round(3)
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