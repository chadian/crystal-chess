require "spec"
require "../../src/board"
require "../../src/piece"

empty_board = [
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
]

class PieceWithNoMoves < Piece
  def moves : Array(PieceMovement)
    [] of PieceMovement
  end

  def capture_moves : Array(PieceMovement)
    [] of PieceMovement
  end
end

class ForwardMovingPieceWithoutCaptureMoves < Piece
  def moves : Array(PieceMovement)
    [{Direction::N, 1}] of PieceMovement
  end

  def capture_moves : Array(PieceMovement)
    [] of PieceMovement
  end
end

class ForwardMovingPieceWithCaptureMove < Piece
  def moves : Array(PieceMovement)
    [{Direction::N, 1}] of PieceMovement
  end

  def capture_moves : Array(PieceMovement)
    [{Direction::N, 1}] of PieceMovement
  end
end

describe "Board" do
  it "initializes with an empty array" do
    board = Board.new

    # 8 x 8 array of `nil`
    board.structure.should eq empty_board
  end

  describe "#add_piece" do
    it "can add a piece at specific coordinates" do
      board = Board.new

      top_left_piece = Pawn.new(PieceColor::White)
      bottom_left_piece = Pawn.new(PieceColor::White)
      top_right_piece = Pawn.new(PieceColor::White)
      bottom_right_piece = Pawn.new(PieceColor::White)

      board.add_piece({'a', 1}, bottom_left_piece)
      board.add_piece({'a', 8}, top_left_piece)
      board.add_piece({'h', 8}, top_right_piece)
      board.add_piece({'h', 1}, bottom_right_piece)

      board.structure.should eq [
        [top_left_piece, nil, nil, nil, nil, nil, nil, top_right_piece],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [bottom_left_piece, nil, nil, nil, nil, nil, nil, bottom_right_piece],
      ]
    end

    it "raises when a piece already exists" do
      board = Board.new
      piece = Pawn.new(PieceColor::White)
      board.add_piece({'a', 1}, piece)

      another_piece = Pawn.new(PieceColor::White)

      expect_raises(Exception) do
        board.add_piece({'a', 1}, another_piece)
      end
    end
  end

  it "#piece_at_coordinate returns `Piece` at coordinate" do
    board = Board.new
    piece = Pawn.new(PieceColor::White)
    board.add_piece({'a', 1}, piece)

    board.piece_at_coordinate({'a', 1}).should eq piece
  end

  it "#clear_coordinate clears a piece at a specific coordinate" do
    board = Board.new
    piece = Pawn.new(PieceColor::White)
    board.add_piece({'a', 8}, piece)
    board.structure[0][0].should eq piece

    board.clear_coordinate({'a', 8})
    board.structure[0][0].should eq nil
  end

  describe "#move" do
    it "raises when there is no piece at the `from` argument's coordinates" do
      board = Board.new
      expect_raises(Exception) do
        board.move({'a', 1}, {'a', 2})
      end
    end

    it "raises when the piece being moved does not include as one of its valid moves" do
      board = Board.new

      piece = PieceWithNoMoves.new(PieceColor::Black)
      piece_coordinate = {'a', 1}
      board.add_piece(piece_coordinate, piece)

      expect_raises(Exception) do
        board.move(piece_coordinate, {'a', 2})
      end
    end

    it "raises when the piece being moved cannot capture the piece on the square it is moving to" do
      board = Board.new

      moving_piece = ForwardMovingPieceWithoutCaptureMoves.new PieceColor::Black
      piece_on_to_coordinate = PieceWithNoMoves.new PieceColor::White
      from_coordinate = {'a', 1}
      to_coordinate = {'a', 2}

      board.add_piece(from_coordinate, moving_piece)
      board.add_piece(to_coordinate, piece_on_to_coordinate)

      expect_raises(Exception) do
        board.move(from_coordinate, to_coordinate)
      end
    end

    it "allows piece to move" do
      board = Board.new
      piece = ForwardMovingPieceWithCaptureMove.new PieceColor::Black
      from_coordinate = {'a', 1}
      to_coordinate = {'a', 2}

      board.add_piece(from_coordinate, piece)
      captured_piece = board.move(from_coordinate, to_coordinate)
      captured_piece.should be nil
      board.piece_at_coordinate(from_coordinate).should be nil
      board.piece_at_coordinate(to_coordinate).should be piece
    end

    it "allows capturing move when the piece can capture" do
      board = Board.new

      moving_piece = ForwardMovingPieceWithCaptureMove.new PieceColor::Black
      piece_on_to_coordinate = PieceWithNoMoves.new PieceColor::White
      from_coordinate = {'a', 1}
      to_coordinate = {'a', 2}

      board.add_piece(from_coordinate, moving_piece)
      board.add_piece(to_coordinate, piece_on_to_coordinate)

      captured_piece = board.move(from_coordinate, to_coordinate)
      captured_piece.should be(piece_on_to_coordinate)
      board.piece_at_coordinate(from_coordinate).should be nil
      board.piece_at_coordinate(to_coordinate).should be moving_piece
    end
  end
end
