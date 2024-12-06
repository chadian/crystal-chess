require "./board"
require "./piece"

board = Board.new

# Add white pawns
board.add_piece({'a', 2}, Pawn.new(PieceColor::White))
board.add_piece({'b', 2}, Pawn.new(PieceColor::White))
board.add_piece({'c', 2}, Pawn.new(PieceColor::White))
board.add_piece({'d', 2}, Pawn.new(PieceColor::White))
board.add_piece({'e', 2}, Pawn.new(PieceColor::White))
board.add_piece({'f', 2}, Pawn.new(PieceColor::White))
board.add_piece({'g', 2}, Pawn.new(PieceColor::White))
board.add_piece({'h', 2}, Pawn.new(PieceColor::White))

# Add other white pieces
board.add_piece({'a', 1}, Rook.new(PieceColor::White))
board.add_piece({'b', 1}, Knight.new(PieceColor::White))
board.add_piece({'c', 1}, Bishop.new(PieceColor::White))
board.add_piece({'d', 1}, Queen.new(PieceColor::White))
board.add_piece({'e', 1}, King.new(PieceColor::White))
board.add_piece({'f', 1}, Bishop.new(PieceColor::White))
board.add_piece({'g', 1}, Knight.new(PieceColor::White))
board.add_piece({'h', 1}, Rook.new(PieceColor::White))

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

# A blocked move until capture moves are considered
# board.move({'a', 5}, {'a', 6})
# puts board.draw
