require "./board"
require "./piece"

board = Board.new

# Add white pieces
aPawn = Pawn.new(PieceColor::White, board)
board.add_piece(6, 0, aPawn)
board.add_piece(6, 1, Pawn.new(PieceColor::White, board))
board.add_piece(6, 2, Pawn.new(PieceColor::White, board))
board.add_piece(6, 3, Pawn.new(PieceColor::White, board))
board.add_piece(6, 4, Pawn.new(PieceColor::White, board))
board.add_piece(6, 5, Pawn.new(PieceColor::White, board))
board.add_piece(6, 6, Pawn.new(PieceColor::White, board))
board.add_piece(6, 7, Pawn.new(PieceColor::White, board))

# Add other white pieces
board.add_piece(7, 0, Rook.new(PieceColor::White, board))
board.add_piece(7, 1, Knight.new(PieceColor::White, board))
board.add_piece(7, 2, Bishop.new(PieceColor::White, board))
board.add_piece(7, 3, Queen.new(PieceColor::White, board))
board.add_piece(7, 4, King.new(PieceColor::White, board))
board.add_piece(7, 5, Bishop.new(PieceColor::White, board))
board.add_piece(7, 6, Knight.new(PieceColor::White, board))
board.add_piece(7, 7, Rook.new(PieceColor::White, board))

# # Add black pawns
# board.add_piece(1, 0, Pawn.new(PieceColor::Black))
# board.add_piece(1, 1, Pawn.new(PieceColor::Black))
# board.add_piece(1, 2, Pawn.new(PieceColor::Black))
# board.add_piece(1, 3, Pawn.new(PieceColor::Black))
# board.add_piece(1, 4, Pawn.new(PieceColor::Black))
# board.add_piece(1, 5, Pawn.new(PieceColor::Black))
# board.add_piece(1, 6, Pawn.new(PieceColor::Black))
# board.add_piece(1, 7, Pawn.new(PieceColor::Black))

# # Add other black pieces
# board.add_piece(0, 0, Rook.new(PieceColor::Black))
# board.add_piece(0, 1, Knight.new(PieceColor::Black))
# board.add_piece(0, 2, Bishop.new(PieceColor::Black))
# board.add_piece(0, 3, Queen.new(PieceColor::Black))
# board.add_piece(0, 4, King.new(PieceColor::Black))
# board.add_piece(0, 5, Bishop.new(PieceColor::Black))
# board.add_piece(0, 6, Knight.new(PieceColor::Black))
# board.add_piece(0, 7, Rook.new(PieceColor::Black))

puts board.draw
board.move({'a', 2}, {'a', 3})
puts board.draw
