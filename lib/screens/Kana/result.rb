require_relative "../base"
require_relative "../../kana"
require "set"
require "yaml"
require "json"
require "time"


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
        calculate_results
        check_for_wrong_answers

        header = [
          @style.title_style.render("NAMI"),
          "",
          @style.title_center.render("SESSION RESULTS"),
        ].join("\n")

        content = [
          header,
          "",
          @style.title_center.render("Accuracy"),
          @style.text_center.render("#{@accuracy}%"),
          "",
          @style.title_center.render("Correct   Incorrect"),
          @style.text_center.render("#{@correct}/#{@questions}         #{@incorrect}     "),
          "",
          "Time:                #{@time_minutes}m #{@time_seconds}s",
          "Avg. response        #{@average_response.round(1)}s",
          "Fastest response     #{@fastest_response.round(1)}s",
          "Slowest response     #{@slowest_response.round(1)}s",
          "Best streak          #{@best_streak}",
          "",
          @wrong_responses_content,
          "",

          "[r] Retry  [p] Practice again  [esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @results = params[:results]
      end

      private

      def check_for_wrong_answers
        if @wrong_responses.empty?
          @wrong_responses_content = ""
        else

          wrong_responses_content = @wrong_responses
          .map do |(character, romaji), count|
            "#{character}  #{romaji.ljust(5)} ✗ #{count}"
          end

          needs_practice = wrong_responses_content.empty? ? "" : "Needs Practice"

          @wrong_responses_content = [
            "Needs Practice",
            wrong_responses_content,
          ].join("\n")
        end
      end

      def calculate_results
        answers = @results[:answers]

        @questions = answers.count
        @correct = answers.count { |answer| answer[:correct] }
        @incorrect = answers.count { |answer| answer[:correct] }

        @accuracy = ((@correct.to_f/@questions) * 100).round(2)

        study_data = @results[:study_data]
        duration = study_data[:duration]

        @time_minutes = (duration / 60).floor
        @time_seconds = (duration % 60).floor

        
        @time_responses = []
        answers.each { |answer| @time_responses << answer[:response_time]}

        @average_response = @time_responses.sum.fdiv(@time_responses.size)
        @fastest_response = @time_responses.min
        @slowest_response = @time_responses.max

        @best_streak = 0
        current_streak = 0 
        
        answers.each do | answer |
          if answer[:correct]
            debug("Entree")
            current_streak += 1
            if current_streak > @best_streak 
              @best_streak = current_streak
            end
          else
            current_streak = 0
          end
        end

        @wrong_responses = answers
          .reject { |answer| answer[:correct] }
          .map { |answer| [answer[:character], answer[:correct_answer]] }
          .tally
      end

    end
  end
end