require "spec"
require "../../src/game"

class BoardWithSpiedMove < Board
  getter spied_move_calls
  @spied_move_calls : Array(GameTrackedMove) = [] of GameTrackedMove

  def move(from : BoardCoordinate, to : BoardCoordinate)
    super
    @spied_move_calls.push({from: from, to: to})
  end
end

# Considered valid when from an initial game state via `Game#setup_board`
valid_move_from_coordinate = {'a', 2}
valid_move_to_coordinate = {'a', 3}

make_valid_move = ->(game : Game) {
  game.move(valid_move_from_coordinate, valid_move_to_coordinate)
}

describe "Game" do
  describe "#new" do
    it "can be initialized" do
      game = Game.new
      (game.is_a? Game).should be_true
    end

    it "initializes with the first turn for the white pieces" do
      game = Game.new
      game.turn.should eq PieceColor::White
    end

    it "has a board" do
      game = Game.new
      (game.board.is_a? Board).should be_true
    end
  end

  describe "#setup_board" do
    describe "it setups the board correctly" do
      it "has all the white pieces in the correct location" do
        game = Game.new
        game.setup_board

        (game.board.piece_at_coordinate({'a', 1}).is_a? Rook).should be_true
        (game.board.piece_at_coordinate({'b', 1}).is_a? Knight).should be_true
        (game.board.piece_at_coordinate({'c', 1}).is_a? Bishop).should be_true
        (game.board.piece_at_coordinate({'d', 1}).is_a? Queen).should be_true
        (game.board.piece_at_coordinate({'e', 1}).is_a? King).should be_true
        (game.board.piece_at_coordinate({'f', 1}).is_a? Bishop).should be_true
        (game.board.piece_at_coordinate({'g', 1}).is_a? Knight).should be_true
        (game.board.piece_at_coordinate({'h', 1}).is_a? Rook).should be_true

        (game.board.piece_at_coordinate({'a', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'b', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'c', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'d', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'e', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'f', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'g', 2}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'h', 2}).is_a? Pawn).should be_true

        ((game.board.piece_at_coordinate({'a', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'b', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'c', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'d', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'e', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'f', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'g', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'h', 1}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'a', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'b', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'c', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'d', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'e', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'f', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'g', 2}).as Piece).color).should eq PieceColor::White
        ((game.board.piece_at_coordinate({'h', 2}).as Piece).color).should eq PieceColor::White
      end

      it "has all the black pieces in the correct location" do
        game = Game.new
        game.setup_board

        (game.board.piece_at_coordinate({'a', 8}).is_a? Rook).should be_true
        (game.board.piece_at_coordinate({'b', 8}).is_a? Knight).should be_true
        (game.board.piece_at_coordinate({'c', 8}).is_a? Bishop).should be_true
        (game.board.piece_at_coordinate({'d', 8}).is_a? Queen).should be_true
        (game.board.piece_at_coordinate({'e', 8}).is_a? King).should be_true
        (game.board.piece_at_coordinate({'f', 8}).is_a? Bishop).should be_true
        (game.board.piece_at_coordinate({'g', 8}).is_a? Knight).should be_true
        (game.board.piece_at_coordinate({'h', 8}).is_a? Rook).should be_true

        (game.board.piece_at_coordinate({'a', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'b', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'c', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'d', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'e', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'f', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'g', 7}).is_a? Pawn).should be_true
        (game.board.piece_at_coordinate({'h', 7}).is_a? Pawn).should be_true

        ((game.board.piece_at_coordinate({'a', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'b', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'c', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'d', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'e', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'f', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'g', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'h', 7}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'a', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'b', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'c', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'d', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'e', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'f', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'g', 8}).as Piece).color).should eq PieceColor::Black
        ((game.board.piece_at_coordinate({'h', 8}).as Piece).color).should eq PieceColor::Black
      end
    end
  end

  describe "#move" do
    it "raises when the from coordinate does not have a piece to be moved" do
      game = Game.new

      expect_raises(Exception, "Expected the `from` argument to be the coordinate of a piece") do
        game.move({'a', 1}, {'a', 2})
      end
    end

    it "raises when the from coordinate is a piece color that is not the current Game @turn" do
      game = Game.new
      game.setup_board

      black_pawn_coordinate = {'a', 7}
      black_pawn_forward_coordinate = {'a', 6}
      black_pawn = game.board.piece_at_coordinate black_pawn_coordinate
      (black_pawn.as Piece).color.should eq PieceColor::Black

      game.turn.should eq PieceColor::White

      expect_raises(Exception, "turn is set to color White but that piece has color Black") do
        game.move(black_pawn_coordinate, black_pawn_forward_coordinate)
      end
    end

    describe "with a valid move" do
      #  instance replaced in `before_each`, prevents needing to do nil checks or casting
      game : Game = Game.new

      before_each do
        game = Game.new
        game.setup_board
      end

      it "moves a piece when the move is valid and its correct piece color's turn" do
        game.board.piece_at_coordinate(valid_move_from_coordinate).should be_a Pawn
        game.board.piece_at_coordinate(valid_move_to_coordinate).should eq nil

        make_valid_move.call(game)

        game.board.piece_at_coordinate(valid_move_from_coordinate).should be_nil
        game.board.piece_at_coordinate(valid_move_to_coordinate).should be_a Pawn
      end

      it "moves a piece and switches changes the assigned color to @turn" do
        game.turn.should eq PieceColor::White
        make_valid_move.call(game)
        game.turn.should eq PieceColor::Black
      end

      it "calls #move on the underlying Board class" do
        spied_board = BoardWithSpiedMove.new
        # Create game with spied board
        game = Game.new spied_board
        game.setup_board

        ((game.board).as BoardWithSpiedMove).spied_move_calls.should eq([] of Array(GameTrackedMove))

        make_valid_move.call(game)

        ((game.board).as BoardWithSpiedMove).spied_move_calls.should eq([{from: valid_move_from_coordinate, to: valid_move_to_coordinate}])
      end

      it "tracks captured pieces when a capturing move is made (white captures black)" do
        game = Game.new
        white_queen = Queen.new(PieceColor::White)
        black_queen = Queen.new(PieceColor::Black)

        game.board.add_piece({'a', 1}, white_queen)
        game.board.add_piece({'a', 2}, black_queen)
        game.move({'a', 1}, {'a', 2})

        game.captured_pieces[:black].size.should eq 0
        game.captured_pieces[:white].size.should eq 1
        game.captured_pieces[:white][0].should eq black_queen
      end

      it "tracks captured pieces when a capturing move is made (black captures white)" do
        game = Game.new
        white_queen = Queen.new(PieceColor::White)
        black_queen = Queen.new(PieceColor::Black)

        game.board.add_piece({'a', 1}, white_queen)
        game.board.add_piece({'a', 2}, black_queen)

        # move white queen, making it black's turn
        game.move({'a', 1}, {'b', 1})

        # move black queen to capture white queen
        game.move({'a', 2}, {'b', 1})

        game.captured_pieces[:white].size.should eq 0
        game.captured_pieces[:black].size.should eq 1
        game.captured_pieces[:black][0].should eq white_queen
      end
    end
  end
end
