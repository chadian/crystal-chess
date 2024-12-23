require "colorize"
require "./piece"
require "./spatial"

# TODO
# - [ ] Out of board checks (can't run off the bounds of the board)
# - [ ] Collision checks (can't hop enroute to destination except for knights)

PieceCharacterSymbol = {
  Pawn:   "♟",
  Rook:   "♜",
  Knight: "♞",
  Bishop: "♝",
  Queen:  "♛",
  King:   "♚",
}

DEFAULT_BOARD_RANK_COUNT = 8
DEFAULT_BOARD_FILE_COUNT = 8

class Board
  getter structure : BoardStructure

  def initialize(structure : BoardStructure? = nil)
    if structure.nil?
      @structure = Array.new(DEFAULT_BOARD_RANK_COUNT) { Array(Piece | Nil).new(DEFAULT_BOARD_FILE_COUNT, nil) }
      return
    end

    raise "Array structure for board is invalid, #{structure}" if valid_board_structure?(structure) == false
    @structure = structure
  end

  def add_piece(coordinate : BoardCoordinate, piece : Piece)
    existing_piece = piece_at_coordinate(coordinate)

    if !existing_piece.nil?
      raise "Cannot add piece #{piece} to #{coordinate}, an existing piece #{existing_piece} exists at that coordinate"
    end

    array_coordinates = convert_board_coordinate_to_array_matrix_coordinate(coordinate)
    @structure[array_coordinates[0]][array_coordinates[1]] = piece
  end

  def clear_coordinate(coordinate : BoardCoordinate)
    array_coordinates = convert_board_coordinate_to_array_matrix_coordinate(coordinate)
    @structure[array_coordinates[0]][array_coordinates[1]] = nil
  end

  def piece_at_coordinate(coordinate : BoardCoordinate) : Piece?
    array_coordinates = convert_board_coordinate_to_array_matrix_coordinate(coordinate)
    piece = @structure[array_coordinates[0]][array_coordinates[1]]
    piece
  end

  def move(from : BoardCoordinate, to : BoardCoordinate) : Piece | Nil
    from_array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate(from)
    to_array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate(to)

    piece = @structure[from_array_matrix_coordinate[0]][from_array_matrix_coordinate[1]]

    if piece.nil?
      raise "No piece found at #{from}"
    end

    movement = create_movement(from, to)
    piece_at_to_coordinate = @structure[to_array_matrix_coordinate[0]][to_array_matrix_coordinate[1]]
    is_capture_move = !piece_at_to_coordinate.nil?

    is_valid_move = false
    if is_capture_move
      is_valid_move = piece.capture_moves.includes?(movement) && piece.color.inverse == (piece_at_to_coordinate.as Piece).color
    else
      is_valid_move = piece.moves.includes?(movement)
    end

    if !is_valid_move
      raise "Movement #{from} -> #{to} is not a valid movement for piece #{piece.class.name}"
    end

    # can assume can_capture is `true` because its been checked to be a valid above
    if move_blocked?(from, to, {can_capture: true})
      raise "Movement #{from} -> #{to} is blocked"
    end

    # clear existing piece being moved from its previous coordinate
    @structure[from_array_matrix_coordinate[0]][from_array_matrix_coordinate[1]] = nil

    # move piece to its new coordinate
    @structure[to_array_matrix_coordinate[0]][to_array_matrix_coordinate[1]] = piece

    piece_at_to_coordinate
  end

  def move_blocked?(start : BoardCoordinate, to : BoardCoordinate, options : {can_capture: Bool}) : Bool
    movement = create_movement start, to
    direction = movement[0]
    count = movement[1]

    # jumps are only considered blocked if the `to` board coordinate is blocked by a piece and `can_capture` is false
    if count.is_a? Jump
      return piece_at_coordinate(to).nil? ? false : !options[:can_capture]
    end

    start_coordinate = convert_board_coordinate_to_array_matrix_coordinate(start)
    current_row = start_coordinate[0]
    current_column = start_coordinate[1]
    on_square = @structure[current_row][current_column]

    1.upto(count) do |step|
      case direction
      when Direction::N
        current_row -= 1
      when Direction::NE
        current_row -= 1
        current_column += 1
      when Direction::E
        current_column += 1
      when Direction::SE
        current_row += 1
        current_column += 1
      when Direction::S
        current_row += 1
      when Direction::SW
        current_row += 1
        current_column -= 1
      when Direction::W
        current_column -= 1
      when Direction::NW
        current_row -= 1
        current_column -= 1
      end

      on_square = @structure[current_row][current_column]

      # on final step
      if count == step
        # on final step, the square must be empty or capturable
        return on_square.nil? ? false : !options[:can_capture]
      elsif !on_square.nil?
        # en route, the current square is not empty
        return true
      end
    end

    false
  end

  def draw
    dark_tile = :green
    light_tile = :yellow
    current_color = dark_tile

    draw_output = ""

    @structure.each_index do |row_index|
      row = @structure[row_index]
      current_color = current_color == dark_tile ? light_tile : dark_tile

      row.each_index do |column_index|
        square = @structure[row_index][column_index]

        if column_index == 0
          # output edge of board rank markers
          draw_output += "#{8 - row_index} "
        end

        current_color = current_color == dark_tile ? light_tile : dark_tile

        if square == nil
          draw_output += "   ".colorize.on(current_color).fore(:red).to_s
        else
          piece_character = PieceCharacterSymbol[square.class.name]
          draw_output += " #{piece_character} ".colorize.on(current_color).fore((square.as Piece).color.to_s == "White" ? :white : :black).to_s
        end
      end

      draw_output += "\n"
    end

    # output edge of board file markers
    draw_output += "   a  b  c  d  e  f  g  h"
  end

  def clone : Board
    cloned_structure = @structure.map do |rank|
      rank.dup
    end

    Board.new(cloned_structure)
  end

  private def valid_board_structure?(structure : BoardStructure) : Bool
    return false if structure.size != DEFAULT_BOARD_RANK_COUNT

    structure.each do |file|
      return false if structure.size != DEFAULT_BOARD_FILE_COUNT

      file.each do |piece_or_nil|
        # Realistically, this is expected to be caught by the compiler
        return false if piece_or_nil != nil && piece_or_nil.is_a? Piece != true
      end
    end

    true
  end
end
