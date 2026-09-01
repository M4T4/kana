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
          "Time:                #{@minutes}m #{@seconds}s",
          "Avg. response        3.1s",
          "Fastest response     3.1s",
          "Slowest response     3.1s",
          "Best streak          12",
          "",
          "Needs Practice",
          "ぬ  nu     ✗ 3",
          "ぬ  nu     ✗ 3",
          "ぬ  nu     ✗ 3",
          "",

          "[r] Retry  [p] Practice again  [esc] Back"
        ].join("\n")

        center_box(content)
      end

      def enter(params= {})
        @results = params[:results]
      end

      private

      def calculate_results
        @questions = @results.count
        @correct = @results.count { |result| result[:correct] }
        @incorrect = @results.count { |result| !result[:correct] }

        @accuracy = ((@correct.to_f/@questions) * 100).round(2)

        study_data = @results[0][:study_data]
        duration = study_data[:duration]

        @minutes = (duration / 60).floor
        @seconds = (duration % 60).floor
      end

    end
  end
end