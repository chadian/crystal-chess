enum PieceColor
  White
  Black
end

alias PieceCoordinate = {Int32, Int32}

enum Direction
  N
  NE
  E
  SE
  S
  SW
  W
  NW
end

ForwardDirection = {
  PieceColor::White => Direction::N,
  PieceColor::Black => Direction::S,
}

# Describes the movement of Knights
# LONG - The jump starts with two squares and then one over
# SHORT - The jump starts with one forward and then two over
enum JUMP
  LONG
  SHORT
end

MAX_MOVE_SQUARES = 7

alias PieceMovement = {Direction, Int32} | {Direction, Int32}

abstract class Piece
  getter color : PieceColor

  def initialize(@color, @board : Board)
  end

  def coordinates : PieceCoordinate | Nil
    @board.structure.each_index do |rank_index|
      rank = @board.structure[rank_index]

      rank.each_index do |file_index|
        piece = rank[file_index]
        if (self == piece)
          return {rank_index, file_index}
        end
      end
    end

    return nil
  end
end

class Pawn < Piece
  def moves : Array(PieceMovement)
    if (@color == PieceColor::White)
      [{Direction::N, 1}]
    else
      [{Direction::S, 1}]
    end
  end
end

class Rook < Piece
  def moves
  end
end

class Knight < Piece
  def moves
  end
end

class Bishop < Piece
  def moves
  end
end

class Queen < Piece
  def moves
  end
end

class King < Piece
  def moves
  end
end
