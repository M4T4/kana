class Kanji
  attr_reader :character, :meaning, :onyomi, :kunyomi, :jlpt

  def initialize(
    character:,
    meaning:,
    onyomi: [],
    kunyomi: [],
    jlpt: nil
  )
    @character = character
    @meaning = meaning
    @onyomi = onyomi
    @kunyomi = kunyomi
    @jlpt = jlpt
  end
end