require "./board"
require "./piece"

board = Board.new

# Add white pieces
board.add_piece(6, 0, Pawn.new(PieceColor::White, board))
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

board.move({'d', 2}, {'d', 3})
puts board.draw

board.move({'a', 4}, {'a', 5})
puts board.draw

board.move({'a', 5}, {'a', 6})
puts board.draw

board.move({'a', 1}, {'a', 5})
puts board.draw

board.move({'b', 1}, {'a', 3})
puts board.draw

board.move({'a', 3}, {'c', 4})
puts board.draw

board.move({'c', 4}, {'e', 3})
puts board.draw
