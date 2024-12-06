require "./spatial"

enum PieceColor
  White
  Black

  def inverse
    self == PieceColor::White ? PieceColor::Black : PieceColor::White
  end
end

MAX_SQUARE_MOVES = 7

abstract class Piece
  getter color : PieceColor

  def initialize(@color)
  end

  abstract def moves : Array(PieceMovement)
  abstract def capture_moves : Array(PieceMovement)
end

class Pawn < Piece
  def moves : Array(PieceMovement)
    direction = @color == PieceColor::White ? Direction::N : Direction::S
    (1..2).to_a.map { |count| {direction, count}.as PieceMovement }
  end

  # TODO: Allow for pawn capture by "en-passant":
  # https://www.chess.com/terms/en-passant
  def capture_moves : Array(PieceMovement)
    direction = @color == PieceColor::White ? Direction::N : Direction::S
    direction === Direction::N ? [{Direction::NE, 1}.as PieceMovement, {Direction::NW, 1}.as PieceMovement] : [{Direction::SE, 1}.as PieceMovement, {Direction::SW, 1}.as PieceMovement]
  end
end

class Rook < Piece
  def moves : Array(PieceMovement)
    (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::N, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::S, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::E, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::W, count}.as PieceMovement }
  end

  def capture_moves : Array(PieceMovement)
    self.moves
  end
end

class Knight < Piece
  def moves : Array(PieceMovement)
    [Direction::NE, Direction::SE, Direction::SW, Direction::NW].flat_map do |direction|
      [{direction, Jump::SHORT}.as PieceMovement, {direction, Jump::LONG}.as PieceMovement]
    end
  end

  def capture_moves : Array(PieceMovement)
    self.moves
  end
end

class Bishop < Piece
  def moves : Array(PieceMovement)
    (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::NE, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::SE, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::SW, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::NW, count}.as PieceMovement }
  end

  def capture_moves : Array(PieceMovement)
    self.moves
  end
end

class Queen < Piece
  def moves : Array(PieceMovement)
    (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::N, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::NE, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::E, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::SE, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::S, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::SW, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::W, count}.as PieceMovement } +
      (1..MAX_SQUARE_MOVES).to_a.map { |count| {Direction::NW, count}.as PieceMovement }
  end

  def capture_moves : Array(PieceMovement)
    self.moves
  end
end

class King < Piece
  def moves : Array(PieceMovement)
    [
      {Direction::N, 1}.as PieceMovement,
      {Direction::NE, 1}.as PieceMovement,
      {Direction::E, 1}.as PieceMovement,
      {Direction::SE, 1}.as PieceMovement,
      {Direction::S, 1}.as PieceMovement,
      {Direction::SW, 1}.as PieceMovement,
      {Direction::W, 1}.as PieceMovement,
      {Direction::NW, 1}.as PieceMovement,
    ]
  end

  def capture_moves : Array(PieceMovement)
    self.moves
  end
end
