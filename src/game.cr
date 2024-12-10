require "./board"

alias GameTrackedMove = NamedTuple(from: BoardCoordinate, to: BoardCoordinate)

class Game
  getter board : Board
  getter turn : PieceColor

  @moves : Array(GameTrackedMove) = [] of GameTrackedMove

  def initialize(board : Board = Board.new)
    @board = board
    @turn = PieceColor::White
  end

  def setup_board
    add_starting_white_pieces
    add_starting_black_pieces
  end

  def move(from : BoardCoordinate, to : BoardCoordinate)
    piece_to_move = board.piece_at_coordinate from

    if piece_to_move.nil?
      raise "Expected the `from` argument to be the coordinate of a piece"
    end

    if piece_to_move.color != @turn
      raise "Cannot move piece #{piece_to_move} at #{from} because the turn is set to color #{@turn} but that piece has color #{piece_to_move.color}"
    end

    captured_piece = board.move(from, to)
    @moves.push({from: from, to: to})
    @turn = @turn.inverse
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
