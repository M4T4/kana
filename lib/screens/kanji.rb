require "lipgloss"

module Screens
  class MainMenu 
    WIDTH = 44

  end

end


# Old methods to load the kanji that I had.
  # def next_kanji
  #   @index = (@index + 1) % @kanjis.size
  #   @revealed = false
  # end

  # def load_kanjis
  #   path = File.expand_path("../data/kanji.yml", __dir__)

  #   YAML.load_file(path).map do |data|
  #     Kanji.new(
  #       character: data["character"],
  #       meaning: data["meaning"],
  #       onyomi: data["onyomi"] || [],
  #       kunyomi: data["kunyomi"] || [],
  #       jlpt: data["jlpt"]
  #     )
  #   end
  # end