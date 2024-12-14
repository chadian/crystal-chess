require "colorize"
require "./game"

class Interactive
  getter game : Game

  def initialize(game : Game = Game.new)
    # Assume that if no moves have been played that the game's board
    # should be setup with all the pieces needed for a new game
    if game.moves.size == 0
      game.setup_board
    end

    @game = game
  end

  def load_game(game : Game)
    @game = game
  end

  def move_input : GameTrackedMove?
    puts "Enter a move by specifying both coordinates separated by a space (eg: \"a2 a3\"):"
    from_stdin = STDIN.gets
    puts "\n"

    if from_stdin.nil?
      return nil
    end

    coordinates = from_stdin.chomp.split(" ")
    if coordinates.size != 2
      puts "Invalid input, specify both coordinates separated by a space (eg: \"a2 a3\"):"
      nil
    end

    board_coordinates : Array(BoardCoordinate) = coordinates.map do |coordinate|
      invalid_coordinate_message = "Invalid coordinate #{coordinate}. Coordinate should be a letter and a number, like \"a2\""
      if coordinate.size != 2
        puts invalid_coordinate_message
        return nil
      end

      rank_and_file = coordinate.split("")
      board_movement = {rank_and_file[0][0], rank_and_file[1].to_i}
      convert_board_coordinate_to_array_matrix_coordinate(board_movement)
      board_movement
    end

    {from: board_coordinates[0], to: board_coordinates[1]}
  end

  def game_header
    white_circle = "●"
    black_circle = "○"
    current_turn_circle = @game.turn.to_sym == :white ? white_circle : black_circle

    game_header = <<-GAME_HEADER
    #{"Current turn".colorize.bright}
      #{current_turn_circle} #{@game.turn.to_s.downcase}
    #{"Captured pieces".colorize(:white).bright}
      by white           #{@game.captured_pieces[:white].size}
      by black           #{@game.captured_pieces[:black].size}
    GAME_HEADER

    game_header
  end

  def loop
    # draw initial board
    puts game_header
    puts ""
    puts @game.board.draw
    puts ""

    loop do
      move = move_input

      if move.nil?
        # skip until a valid move is given
        next
      end

      exception : Exception? = nil
      begin
        @game.move(move[:from], move[:to])
      rescue ex : Exception
        exception = ex
      end

      if !exception.nil?
        puts "Error: #{exception.message}".colorize(:light_red)
        puts ""
      end

      puts game_header
      puts ""
      puts @game.board.draw
      puts ""
    end
  end
end
