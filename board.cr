require "colorize"
require "./piece"

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

alias BoardCooardinate = {Char, Int32}
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

def convert_board_coordinate_to_structure(coordinate : BoardCooardinate) : StructureCoordinate
  file = coordinate[0]
  rank = coordinate[1]

  file = file.downcase

  file_number = FileNumber[file.to_s] - 1

  {8 - rank, file_number}
end

def createMovement(from : BoardCoordinate, to : BoardCoordinate) : PieceMovement
  from_rank_number = from[1]
  from_file_number = FileNumber[from[0]]
  to_rank_number = to[1]
  to_file_number = FileNumber[to[0]]

  horizonal_movement = from_rank_number != to_rank_number
  vertical_movement = from_file_number != to_file_number

  if (horizontal_movement)
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

  def move(from : BoardCooardinate, to : BoardCooardinate)
    from_structure_coordinate = convert_board_coordinate_to_structure(from)
    to_structure_coordinate = convert_board_coordinate_to_structure(to)

    piece = @structure[from_structure_coordinate[0]][from_structure_coordinate[1]]

    if (piece.is_a? Nil)
      raise "No piece found at #{from}"
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
