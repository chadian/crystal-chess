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

  describe "#move_blocked?" do
    describe "when there is no piece blocking movement" do
      board = Board.new
      from_coordinate = {'a', 1}
      to_coordinate = {'a', 2}

      before_each do
        board = Board.new
        moving_piece = ForwardMovingPieceWithoutCaptureMoves.new PieceColor::Black
        board.add_piece(from_coordinate, moving_piece)
      end

      it "returns false when can_capture is false" do
        result = board.move_blocked?(from_coordinate, to_coordinate, {can_capture: false})
        result.should eq false
      end

      it "returns false when can_capture is true" do
        result = board.move_blocked?(from_coordinate, to_coordinate, {can_capture: true})
        result.should eq false
      end
    end

    describe "when non-jump movements are blocked" do
      board : Board = Board.new
      from_coordinate = {'a', 1}
      blocked_to_coordinate = {'a', 2}

      before_each do
        board = Board.new
        moving_piece = ForwardMovingPieceWithoutCaptureMoves.new PieceColor::Black
        blocking_piece_on_to_coordinate = PieceWithNoMoves.new PieceColor::White
        board.add_piece(from_coordinate, moving_piece)
        board.add_piece(blocked_to_coordinate, blocking_piece_on_to_coordinate)
      end

      it "returns true when can_capture is false" do
        result = board.move_blocked?(from_coordinate, blocked_to_coordinate, {can_capture: false})
        result.should eq true
      end

      it "returns false when can_capture is true" do
        result = board.move_blocked?(from_coordinate, blocked_to_coordinate, {can_capture: true})
        result.should eq false
      end
    end

    describe "when jump movements are blocked" do
      board : Board = Board.new
      from_coordinate = {'a', 1}
      blocked_to_coordinate = {'c', 2}

      before_each do
        board = Board.new
        jumping_piece = Knight.new PieceColor::Black
        blocking_piece_on_to_coordinate = PieceWithNoMoves.new PieceColor::White
        surrounding_blocking_piece_1 = PieceWithNoMoves.new PieceColor::White
        surrounding_blocking_piece_2 = PieceWithNoMoves.new PieceColor::White
        surrounding_blocking_piece_3 = PieceWithNoMoves.new PieceColor::White
        surrounding_blocking_piece_4 = PieceWithNoMoves.new PieceColor::White

        board.add_piece(from_coordinate, jumping_piece)
        board.add_piece(blocked_to_coordinate, blocking_piece_on_to_coordinate)

        # Add pieces all surrounding the squares en route to the "to_coordinate" to
        # test that jumps are not impacted by pieces "in the way"
        board.add_piece({'a', 2}, surrounding_blocking_piece_1)
        board.add_piece({'b', 1}, surrounding_blocking_piece_2)
        board.add_piece({'b', 2}, surrounding_blocking_piece_3)
        board.add_piece({'c', 1}, surrounding_blocking_piece_4)
      end

      it "returns false when can_capture is true" do
        result = board.move_blocked?(from_coordinate, blocked_to_coordinate, {can_capture: true})
        result.should eq false
      end

      it "returns true when can_capture is false" do
        result = board.move_blocked?(from_coordinate, blocked_to_coordinate, {can_capture: false})
        result.should eq true
      end
    end
  end
end
