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

puts board.draw

board.move({'a', 2}, {'a', 4})
puts board.draw
