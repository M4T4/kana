class Kana
  attr_reader :family,
              :group,
              :syllabary,
              :character,
              :romaji

  # A Kana object could be:
  # 
  # Example A: 
  # Kana(
  # family: "Gojūon",
  # group: "ka",
  # syllabary: "hiragana",
  # character: "か",
  # romaji: "ka"
  # )
  # 
  # Example B: 
  # Kana(
  # family: "Gojūon",
  # group: "ka",
  # syllabary: "hiragana",
  # character: "け",
  # romaji: "ke"
  # )

  def initialize(family:, group:, syllabary:, character:, romaji:)
    @family = family
    @group = group
    @syllabary = syllabary
    @character = character
    @romaji = romaji
  end
end