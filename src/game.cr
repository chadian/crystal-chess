require "./board"

class Game
  getter board

  def initialize
    @board = Board.new
  end

  def setup_board
    add_starting_white_pieces
    add_starting_black_pieces
  end

  private def add_starting_white_pieces
    board.add_piece({'a', 1}, Rook.new(PieceColor::White))
    board.add_piece({'b', 1}, Knight.new(PieceColor::White))
    board.add_piece({'c', 1}, Bishop.new(PieceColor::White))
    board.add_piece({'d', 1}, Queen.new(PieceColor::White))
    board.add_piece({'e', 1}, King.new(PieceColor::White))
    board.add_piece({'f', 1}, Bishop.new(PieceColor::White))
    board.add_piece({'g', 1}, Knight.new(PieceColor::White))
    board.add_piece({'h', 1}, Rook.new(PieceColor::White))

    board.add_piece({'a', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'b', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'c', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'d', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'e', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'f', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'g', 2}, Pawn.new(PieceColor::White))
    board.add_piece({'h', 2}, Pawn.new(PieceColor::White))
  end

  private def add_starting_black_pieces
    board.add_piece({'a', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'b', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'c', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'d', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'e', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'f', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'g', 7}, Pawn.new(PieceColor::Black))
    board.add_piece({'h', 7}, Pawn.new(PieceColor::Black))

    board.add_piece({'a', 8}, Rook.new(PieceColor::Black))
    board.add_piece({'b', 8}, Knight.new(PieceColor::Black))
    board.add_piece({'c', 8}, Bishop.new(PieceColor::Black))
    board.add_piece({'d', 8}, Queen.new(PieceColor::Black))
    board.add_piece({'e', 8}, King.new(PieceColor::Black))
    board.add_piece({'f', 8}, Bishop.new(PieceColor::Black))
    board.add_piece({'g', 8}, Knight.new(PieceColor::Black))
    board.add_piece({'h', 8}, Rook.new(PieceColor::Black))
  end
end
