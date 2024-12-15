require "spec"
require "../../src/interactive"

class InteractiveTestable < Interactive
  property mocked_stdin_returns = [] of String?
  property mocked_stdin_returns_next_index : Int32 = 0
  getter mocked_captured_output : Array(String) = [] of String

  def stdin
    gets_return = @mocked_stdin_returns[@mocked_stdin_returns_next_index]

    # auto-advance the index
    @mocked_stdin_returns_next_index = @mocked_stdin_returns_next_index + 1

    gets_return
  end

  def output(str : String)
    @mocked_captured_output << str
  end

  def continue_game_loop
    super
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
    around_each do |test|
      existing_colorized_enabled = Colorize.enabled?
      # Needed in order to do a clearer string comparison for #game_header
      # otherwise the colorized terminal codes are mixed within the string
      # and it's harder to assert the text on the test
      Colorize.enabled = false

      test.run

      # restore to previous setting
      Colorize.enabled = existing_colorized_enabled
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
    interactive : InteractiveTestable = InteractiveTestable.new

    before_each do
      interactive = InteractiveTestable.new
    end

    it "returns a to/from movement tuple from a valid input" do
      interactive.mocked_stdin_returns = ["a2 a3"] of String?
      result = interactive.move_input
      result.should eq({from: {'a', 2}, to: {'a', 3}})
      interactive.mocked_captured_output.should eq [
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):",
        "\n",
      ]
    end

    it "returns a to/from movement tuple from a valid input (with ending new line \\n characters)" do
      interactive.mocked_stdin_returns = ["a2 a3\n"] of String?
      result = interactive.move_input
      result.should eq({from: {'a', 2}, to: {'a', 3}})
      interactive.mocked_captured_output.should eq [
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):",
        "\n",
      ]
    end

    it "returns nil if the input is invalid" do
      interactive.mocked_stdin_returns = [""] of String?
      result = interactive.move_input
      result.should eq nil
      interactive.mocked_captured_output.should contain "Invalid input, specify both coordinates separated by a space (eg: \"a2 a3\"):"
    end
  end

  describe "#game_loop" do
    interactive : InteractiveTestable = InteractiveTestable.new

    before_each do
      interactive = InteractiveTestable.new
    end
  end
end
