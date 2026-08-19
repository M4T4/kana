class Kana
  attr_reader :character, :meaning, :onyomi, :kunyomi

  def initialize(character:, meaning:, onyomi:, kunyomi:)
    @character = character
    @meaning = meaning
    @onyomi = onyomi
    @kunyomi = kunyomi
  end
end