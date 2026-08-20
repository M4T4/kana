# lib/app.rb

require "yaml"
require "bubbletea"
require "lipgloss"

require_relative "kanji"

class App
  include Bubbletea::Model

  WIDTH = 44

  def initialize
    @width = 0
    @height = 0

    # @index = 0
    # @revealed = false
    # @kanjis = load_kanjis

    @title_style = Lipgloss::Style.new
      .bold(true)
      .align(:left)

    @subtitle_style = Lipgloss::Style.new
      .faint(true)

    @question = Lipgloss::Style.new
      .bold(true)

    @option = Lipgloss::Style.new
      .faint(true)

    @kanji_style = Lipgloss::Style.new
      .bold(true)
      .align(:center)
      .width(WIDTH)

    @jlpt_style = Lipgloss::Style.new
      .faint(true)
      .align(:center)
      .width(WIDTH)

    @label_style = Lipgloss::Style.new
      .bold(true)

    @help_style = Lipgloss::Style.new
      .faint(true)

    @box_style = Lipgloss::Style.new
      .border(:rounded)
      .padding(1, 2)
      .width(WIDTH)
  end

  def init
    [self, nil]
  end

  def update(message)
    case message
    when Bubbletea::WindowSizeMessage
      @width = message.width
      @height = message.height

      [self, nil]
    when Bubbletea::KeyMessage
      if message.space?
        @revealed = true
        return [self, nil]
      end

      case message.to_s
      when "1"
        start_kana
        [self, nil]
      when "2"
        start_kanji
        [self, nil]
      when "1"
        start_vocabulary
        [self, nil]

      when "n", "right"
        next_kanji
        [self, nil]

      when "q", "ctrl+c", "esc"
        [self, Bubbletea.quit]

      else
        [self, nil]
      end
    else
      [self, nil]
    end
  end

  def view
    header = [
      @title_style.render("NAMI"),
      @subtitle_style.render("Japanese Writting System Trainer")
    ].join("\n")

    starting_options = [
      @question.render("Select an option"),
      @option.render("1. Kana あ"),
      @option.render("2. Kanji 日"),
      @option.render("3. Vocabulary 語彙"),
    ]

    help = @help_style.render(
      "[i] Info   [h] help   [q] Quit"
    )

    content = [
      header, 
      "",
      starting_options,
      "",
      help
    ].join("\n")

    box = @box_style.render(content)

    Lipgloss.place(
      @width,
      @height,
      :center,
      :center,
      box
    )
  end

  def kanji_view
    kanji = @kanjis[@index]

    header = [
      @title_style.render("NAMI"),
      @subtitle_style.render("Japanese Writting System Trainer")
    ].join("\n")

    kanji_section = [
      "",
      @kanji_style.render(kanji.character),
      "",
      @jlpt_style.render(kanji.jlpt || "Unknown")
    ].join("\n")

    meaning = @revealed ? kanji.meaning : "???"

    onyomi =
      if @revealed
        kanji.onyomi.any? ? kanji.onyomi.join(", ") : "—"
      else
        "???"
      end

    kunyomi =
      if @revealed
        kanji.kunyomi.any? ? kanji.kunyomi.join(", ") : "—"
      else
        "???"
      end

    
    info = [
      @label_style.render("Meaning"),
      meaning,
      "",
      @label_style.render("Onyomi"),
      onyomi,
      "",
      @label_style.render("Kunyomi"),
      kunyomi
    ].join("\n")
  end

  private

  def next_kanji
    @index = (@index + 1) % @kanjis.size
    @revealed = false
  end

  def load_kanjis
    path = File.expand_path("../data/kanji.yml", __dir__)

    YAML.load_file(path).map do |data|
      Kanji.new(
        character: data["character"],
        meaning: data["meaning"],
        onyomi: data["onyomi"] || [],
        kunyomi: data["kunyomi"] || [],
        jlpt: data["jlpt"]
      )
    end
  end
end