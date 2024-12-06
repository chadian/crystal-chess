require "spec"
require "../../src/board"

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

describe "Board" do
  it "initializes with an empty array" do
    board = Board.new

    # 8 x 8 array of `nil`
    board.structure.should eq empty_board
  end

  it "#add_piece can add a piece at specific coordinates" do
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

  it "#add_piece raises when a piece already exists" do
    board = Board.new
    piece = Pawn.new(PieceColor::White)
    board.add_piece({'a', 1}, piece)

    another_piece = Pawn.new(PieceColor::White)

    expect_raises(Exception) do
      board.add_piece({'a', 1}, another_piece)
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
end
