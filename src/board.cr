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

class Board
  getter structure

  def initialize
    #  create 8x8 board
    @structure = Array(Array(Piece | Nil)).new(8) { Array(Piece | Nil).new(8, nil) }
  end

  # TODO: Convert this to a `BoardCoordinate` input
  def add_piece(x : Number, y : Number, piece : Piece)
    @structure[x][y] = piece
  end

  def move(from : BoardCoordinate, to : BoardCoordinate) : Piece | Nil
    from_array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate(from)
    to_array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate(to)

    piece = @structure[from_array_matrix_coordinate[0]][from_array_matrix_coordinate[1]]

    if piece.nil?
      raise "No piece found at #{from}"
    end

    movement = create_movement(from, to)
    is_valid_piece_move = piece.moves.includes?(movement)

    if !is_valid_piece_move
      raise "Movement #{from} -> #{to} is not a valid movement for piece #{piece.class.name}"
    end

    piece_at_to_coordinate = @structure[to_array_matrix_coordinate[0]][to_array_matrix_coordinate[1]]
    can_capture_piece_at_to_coordinate = piece.capture_moves.includes?(movement) && !piece_at_to_coordinate.nil? && piece.color.inverse == piece_at_to_coordinate.color

    if !piece_at_to_coordinate.nil? && !can_capture_piece_at_to_coordinate
      raise "Movement #{from} -> #{to} is blocked, cannot capture piece #{piece_at_to_coordinate} at #{to}"
    end

    # can assume can_capture is `true` because its been checked to be a valid above
    if is_move_blocked(from, movement, {can_capture: true})
      raise "Movement #{from} -> #{to} is blocked"
    end

    # clear existing piece being moved from its previous coordinate
    @structure[from_array_matrix_coordinate[0]][from_array_matrix_coordinate[1]] = nil

    # move piece to its new coordinate
    @structure[to_array_matrix_coordinate[0]][to_array_matrix_coordinate[1]] = piece

    piece_at_to_coordinate
  end

  def is_move_blocked(start : BoardCoordinate, movement : PieceMovement, can_capture : {can_capture: Bool}) : Bool
    direction = movement[0]
    count = movement[1]

    # jumps are never considered blocked moves, knights are not blocked
    # by pieces in their path
    if count.is_a? Jump
      return false
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
        return on_square.nil? ? false : !can_capture
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

    @structure.each_index do |row_index|
      row = @structure[row_index]
      current_color = current_color == dark_tile ? light_tile : dark_tile

      row.each_index do |column_index|
        square = @structure[row_index][column_index]

        if (column_index == 0)
          # output edge of board rank markers
          print "#{8 - row_index} "
        end

        current_color = current_color == dark_tile ? light_tile : dark_tile

        if square == nil
          print "   ".colorize.on(current_color).fore(:red)
        else
          pieceCharacter = PieceCharacterSymbol[square.class.name]
          print " #{pieceCharacter} ".colorize.on(current_color).fore((square.as Piece).color.to_s == "White" ? :white : :black)
        end
      end
      print "\n"
    end

    # output edge of board file markers
    print "   a  b  c  d  e  f  g  h"
  end
end
