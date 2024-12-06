require "spec"
require "../../src/piece"

describe "PieceColor" do
  it "#inverse returns the opposite color" do
    PieceColor::White.inverse.should eq PieceColor::Black
    PieceColor::Black.inverse.should eq PieceColor::White
  end
end

describe "Piece" do
  it "all pieces can be initialized with Black and White" do
    [Pawn, Rook, Knight, Bishop, Queen, King].each do |piece_class|
      black_piece = piece_class.new(PieceColor::Black)
      black_piece.color.should eq PieceColor::Black

      white_piece = piece_class.new(PieceColor::White)
      white_piece.color.should eq PieceColor::White
    end
  end
end
