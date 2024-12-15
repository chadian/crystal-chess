require "spec"
require "../../src/interactive"

EXISTING_COLORIZE_ENABLED = Colorize.enabled?

class MockStdInReader < StdInReader
  @return_count : Int32 = 0
  property gets_returns : Array(String?) = [] of String?

  def gets
    gets_return = @gets_returns[@return_count]
    @return_count = @return_count + 1
    gets_return
  end
end

describe "Interactive" do
  describe "#initialize" do
    it "creates a new Interactive instance" do
      interactive = Interactive.new
      interactive.should be_a Interactive
    end

    it "has @game with a Game instance" do
      interactive = Interactive.new
      interactive.game.should be_a Game
    end
  end

  describe "#game_header" do
    before_each do
      # Needed in order to do a clearer string comparison for #game_header
      # otherwise the colorized terminal codes are mixed within the string
      # and it's harder to assert the text on the test
      Colorize.enabled = false
    end

    after_each do
      # restore to previous setting
      Colorize.enabled = EXISTING_COLORIZE_ENABLED
    end

    it "represents the initial state of the game" do
      interactive = Interactive.new
      expected_game_header = <<-EXPECTED_GAME_HEADER
      Current turn
         ●  white
      Captured pieces
        by white           0
        by black           0
      EXPECTED_GAME_HEADER

      interactive.game_header.should eq expected_game_header
    end

    it "can reflect black's turn" do
      interactive = Interactive.new
      interactive.game.move({'a', 2}, {'a', 3})

      expected_game_header = <<-EXPECTED_GAME_HEADER
      Current turn
         ○  black
      Captured pieces
        by white           0
        by black           0
      EXPECTED_GAME_HEADER

      interactive.game_header.should eq expected_game_header
    end

    it "can reflect white's turn" do
      interactive = Interactive.new
      # white's initial move
      interactive.game.move({'a', 2}, {'a', 3})

      # black's move, putting it back to white's move
      interactive.game.move({'a', 7}, {'a', 6})

      expected_game_header = <<-EXPECTED_GAME_HEADER
      Current turn
         ●  white
      Captured pieces
        by white           0
        by black           0
      EXPECTED_GAME_HEADER

      interactive.game_header.should eq expected_game_header
    end

    it "has the correct escape codes for current turn circle" do
      # enable color to see escape codes in generated string
      Colorize.enabled = true

      interactive = Interactive.new

      # FIRST ESCAPE: \e[97;40m
      # \e is for for the escape start
      # 97; is for a white bright text
      # 40 is for a black background
      # \m ends the sequence
      #
      # SECOND ESCAPE: \e[0m
      # This resets the colors back to default
      interactive.game_header.should contain("\e[97;40m ● \e[0m")
    end
  end

  describe "#move_input" do
    interactive : Interactive = Interactive.new
    mock_std_in_reader = MockStdInReader.new

    before_each do
      interactive = Interactive.new
      mock_std_in_reader = MockStdInReader.new
      interactive.stdin = mock_std_in_reader
    end

    it "returns a to/from movement tuple from a valid input" do
      mock_std_in_reader.gets_returns = ["a2 a3"] of String?
      result = interactive.move_input
      result.should eq({from: {'a', 2}, to: {'a', 3}})
    end

    it "returns a to/from movement tuple from a valid input (with ending new line \\n characters)" do
      mock_std_in_reader.gets_returns = ["a2 a3\n"] of String?
      result = interactive.move_input
      result.should eq({from: {'a', 2}, to: {'a', 3}})
    end

    it "returns nil if the input is invalid" do
      mock_std_in_reader.gets_returns = [""] of String?
      result = interactive.move_input
      result.should eq nil
    end
  end
end
