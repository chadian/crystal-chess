require "spec"
require "../../src/game"

describe "Game" do
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
end
