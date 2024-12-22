require "spec"
require "../../src/interactive"

class InteractiveTestable < Interactive
  property mocked_stdin_returns = [] of String?
  property mocked_stdin_returns_next_index : Int32 = 0
  getter mocked_captured_output : Array(String) = [] of String

  # overridden for providing mocked inputs instead of stdin
  def stdin
    current_index = @mocked_stdin_returns_next_index

    # auto-advance the index
    @mocked_stdin_returns_next_index += 1

    if current_index > @mocked_stdin_returns.size - 1
      return nil
    end

    @mocked_stdin_returns[current_index]
  end

  # overridden for capturing what would be output to the screen via `puts`
  def output(str : String)
    @mocked_captured_output << str
  end

  # overridden to break for test scenarios, otherwise rely on real `super`
  def continue_game_loop
    # assume the game loop should end when the provided mocked stdin inputs run out
    # This compares against `@mocked_stdin_returns.size` instead of `@mocked_stdin_returns.size - 1`
    # because to get the result of a single loop, it has to capture the input, and start the next loop
    # and freeze on the next iteration
    if @mocked_stdin_returns_next_index > @mocked_stdin_returns.size
      return false
    end

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

  # The `#loop` tests are more like integration style tests capturing the full
  # round trip of the loop. The `captured_output` assertions are easiest maintained
  # by verifying the diff and then copying/pasted the "actual" string if it is correct.
  # This treats these tests as sort of snapshot tests for the types of interactions
  # from mocked stdin inputs
  describe "#loop" do
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

    interactive : InteractiveTestable = InteractiveTestable.new

    before_each do
      interactive = InteractiveTestable.new
    end

    it "outputs the board with the move from the response" do
      interactive.mocked_stdin_returns = ["a2 a3"] of String?
      interactive.loop
      interactive.mocked_captured_output.join("\n").should eq(
        "Current turn\n" +
        "   ●  white\n" +
        "Captured pieces\n" +
        "  by white           0\n" +
        "  by black           0\n" +
        "\n" +
        "8  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "7  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "6                         \n" +
        "5                         \n" +
        "4                         \n" +
        "3                         \n" +
        "2  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "1  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "   a  b  c  d  e  f  g  h\n" +
        "\n" +
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):\n" +
        "\n" +
        "\n" +
        "Current turn\n" +
        "   ○  black\n" +
        "Captured pieces\n" +
        "  by white           0\n" +
        "  by black           0\n" +
        "\n" +
        "8  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "7  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "6                         \n" +
        "5                         \n" +
        "4                         \n" +
        "3  ♟                      \n" +
        "2     ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "1  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "   a  b  c  d  e  f  g  h\n" +
        "\n" +
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):\n" +
        "\n"
      )
    end

    it "outputs warning and and asks again when an empty response is sent" do
      empty_input = "\n"
      interactive.mocked_stdin_returns = [empty_input] of String?
      interactive.loop
      interactive.mocked_captured_output.join("\n").should eq(
        "Current turn\n" +
        "   ●  white\n" +
        "Captured pieces\n" +
        "  by white           0\n" +
        "  by black           0\n" +
        "\n" +
        "8  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "7  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "6                         \n" +
        "5                         \n" +
        "4                         \n" +
        "3                         \n" +
        "2  ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟ \n" +
        "1  ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜ \n" +
        "   a  b  c  d  e  f  g  h\n" +
        "\n" +
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):\n" +
        "\n" +
        "\n" +
        "Invalid input, specify both coordinates separated by a space (eg: \"a2 a3\"):\n" +
        "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):\n" +
        "\n"
      )
    end
  end
end
