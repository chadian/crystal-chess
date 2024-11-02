require "colorize"
require "./piece"

# TODO
# - [ ] Out of board checks (can't run off the bounds of th eboard)
# - [ ] Collision checks (can't hop enroute to destination except for knights)

PieceCharacterSymbol = {
  Pawn:   "♟",
  Rook:   "♜",
  Knight: "♞",
  Bishop: "♝",
  Queen:  "♛",
  King:   "♚",
}

PieceCharacterLetter = {
  Pawn: "P",
  Rook: "R",
  # Fix this, Knight and King can't both be 'K'
  Knight: "K",
  Bishop: "B",
  Queen:  "Q",
  King:   "K",
}

alias BoardCoordinate = {Char, Int32}
alias StructureCoordinate = {Int32, Int32}

FileNumber = {
  a: 1,
  b: 2,
  c: 3,
  d: 4,
  e: 5,
  f: 6,
  g: 7,
  h: 8,
}

def convert_board_coordinate_to_structure(coordinate : BoardCoordinate) : StructureCoordinate
  file = coordinate[0]
  rank = coordinate[1]

  file = file.downcase

  file_number = FileNumber[file.to_s] - 1

  {8 - rank, file_number}
end

def create_movement(from : BoardCoordinate, to : BoardCoordinate) : PieceMovement
  from_rank_number = from[1]
  from_file_number = FileNumber[from[0].to_s]
  to_rank_number = to[1]
  to_file_number = FileNumber[to[0].to_s]

  horizontal_direction : Direction::E | Direction::W | Nil = nil
  vertical_direction : Direction::N | Direction::S | Nil = nil
  count : Int32 | Jump

  horizontal_movement = from_file_number != to_file_number
  if (horizontal_movement)
    horizontal_direction = from_file_number < to_file_number ? Direction::E : Direction::W
  end

  vertical_movement = from_rank_number != to_rank_number
  if vertical_movement
    vertical_direction = from_rank_number < to_rank_number ? Direction::N : Direction::S
  end

  if horizontal_direction
    horizontal_direction = from_file_number < to_file_number ? Direction::E : Direction::W
  end

  horizontal_diff = (from_file_number - to_file_number).abs
  vertical_diff = (from_rank_number - to_rank_number).abs
  is_diagonal_move = horizontal_direction && vertical_direction
  is_knight_jump = (horizontal_diff == 2 && vertical_diff == 1) || (horizontal_diff == 1 && vertical_diff == 2)

  if is_knight_jump
    knight_moves = 4
    knight_movement = case {vertical_direction, vertical_diff, horizontal_direction, horizontal_diff}
                      when {Direction::N, 2, Direction::E, 1}
                        {Direction::NE, Jump::LONG}
                      when {Direction::N, 1, Direction::E, 2}
                        {Direction::NE, Jump::SHORT}
                      when {Direction::S, 2, Direction::E, 1}
                        {Direction::SE, Jump::LONG}
                      when {Direction::S, 1, Direction::E, 2}
                        {Direction::SE, Jump::SHORT}
                      end

    return knight_movement
  end

  if is_diagonal_move
    if horizontal_diff == vertical_diff
      # for non-knights, a valid diagonal in chess is 1:1 for horizontal to
      #  vertical squares a diagonal move counts squares on the diagonal,
      # instead of combining its separate horizontal and vertical counts,
      # and because it's 1:1 horizontal to vertical the diagonal movement is same for either
      count = horizontal_diff
    else
      raise "Movement is not diagonal"
    end
  else
    # either the horizontal_diff is 0 or the vertical_diff is 0
    # since the direction if not diagonal is one along one axis,
    # and therefore the total moves can be added
    count = horizontal_diff + vertical_diff
  end

  case {vertical_direction, horizontal_direction}
  when {Direction::N, nil}
    {Direction::N, count}
  when {Direction::N, Direction::E}
    {Direction::NE, count}
  when {nil, Direction::E}
    {Direction::E, count}
  when {Direction::S, Direction::E}
    {Direction::SE, count}
  when {Direction::S, nil}
    {Direction::S, count}
  when {Direction::S, Direction::W}
    {Direction::SW, count}
  when {nil, Direction::W}
    {Direction::W, count}
  when {Direction::N, Direction::W}
    {Direction::NW, count}
  else
    raise "No direction found"
  end
end

class Board
  getter structure

  def initialize
    #  create 8x8 board
    @structure = Array(Array(Piece | Nil)).new(8) { Array(Piece | Nil).new(8, nil) }
  end

  def add_piece(x : Number, y : Number, piece : Piece)
    @structure[x][y] = piece
  end

  def move(from : BoardCoordinate, to : BoardCoordinate)
    from_structure_coordinate = convert_board_coordinate_to_structure(from)
    to_structure_coordinate = convert_board_coordinate_to_structure(to)

    piece = @structure[from_structure_coordinate[0]][from_structure_coordinate[1]]

    if piece.nil?
      raise "No piece found at #{from}"
    end

    movement = create_movement(from, to)
    has_listed_move = piece.moves.includes?(movement)

    if !has_listed_move
      raise "Movement #{from} -> #{to} is not a valid for piece #{piece.class.name}"
    end

    # clear out existing location of piece
    @structure[from_structure_coordinate[0]][from_structure_coordinate[1]] = nil

    # move to specified square
    @structure[to_structure_coordinate[0]][to_structure_coordinate[1]] = piece
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
          print " #{8 - row_index} "
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
    print "    a  b  c  d  e  f  g  h"
  end
end
