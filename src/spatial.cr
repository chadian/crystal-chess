# Represents a position on the board by a file letter and a rank number
alias BoardCoordinate = {Char, Int32}

# Represents a position within the array matrix representation how pieces are stored
alias ArrayMatrixCoordinate = {Int32, Int32}

# Describes the movement of Knights
# LONG - The jump starts with two squares and then one over
# SHORT - The jump starts with one forward and then two over
enum Jump
  LONG
  SHORT
end

enum Direction
  N
  NE
  E
  SE
  S
  SW
  W
  NW
end

#  Represents a movement for a piece that is either in a direction by a number of squares or
# in a direction described by a "jump" (for knights)
alias PieceMovement = {Direction, Int32} | {Direction, Jump}

# This is 1-indexed because ranks are 1-indexed. This keeps a consistent
# indexing when referring to ranks and files together.
FileNumber = {
  a: 1,
  b: 2,
  c: 3,
  d: 4,
  e: 5,
  f: 6,
  g: 7,
  h: 8,
}

def convert_board_coordinate_to_array_matrix_coordinate(coordinate : BoardCoordinate) : ArrayMatrixCoordinate
  file = coordinate[0]
  # Ranks are 1-indexed and start from the bottom left where the ArrayMatrix structure
  # starts at the top left. So the 8th rank is is actually the 0th index and the 1st rank
  # is the the 0th
  rank = 8 - (coordinate[1])
  file_number = FileNumber[file.downcase.to_s] - 1

  # TODO: Move this check into the `Board` class, assume that a movement could
  # be played on a different board sizes.
  array_matrix_range = 0..7
  if !(array_matrix_range.includes?(file_number)) || !(array_matrix_range.includes?(rank))
    raise "BoardCoordinate #{coordinate} is out of range of the ArrayMatrixCoordinate limits #{array_matrix_range}"
  end

  {rank, file_number}
end

def create_movement(from : BoardCoordinate, to : BoardCoordinate) : PieceMovement
  from_rank_number = from[1]
  from_file_number = FileNumber[from[0].to_s]
  to_rank_number = to[1]
  to_file_number = FileNumber[to[0].to_s]

  horizontal_direction : Direction::E | Direction::W | Nil = nil
  vertical_direction : Direction::N | Direction::S | Nil = nil
  count : Int32 | Jump

  horizontal_diff = (from_file_number - to_file_number).abs
  vertical_diff = (from_rank_number - to_rank_number).abs

  if horizontal_diff != 0
    horizontal_direction = from_file_number < to_file_number ? Direction::E : Direction::W
  end

  if vertical_diff != 0
    vertical_direction = from_rank_number < to_rank_number ? Direction::N : Direction::S
  end

  is_diagonal_move = !horizontal_direction.nil? && !vertical_direction.nil?
  is_knight_jump = (horizontal_diff == 2 && vertical_diff == 1) || (horizontal_diff == 1 && vertical_diff == 2)

  if is_knight_jump
    knight_movement = case {vertical_direction, vertical_diff, horizontal_direction, horizontal_diff}
                      when {Direction::N, 2, Direction::E, 1}
                        {Direction::NE, Jump::LONG}.as PieceMovement
                      when {Direction::N, 1, Direction::E, 2}
                        {Direction::NE, Jump::SHORT}.as PieceMovement
                      when {Direction::N, 2, Direction::W, 1}
                        {Direction::NW, Jump::LONG}.as PieceMovement
                      when {Direction::N, 1, Direction::W, 2}
                        {Direction::NW, Jump::SHORT}.as PieceMovement
                      when {Direction::S, 2, Direction::E, 1}
                        {Direction::SE, Jump::LONG}.as PieceMovement
                      when {Direction::S, 1, Direction::E, 2}
                        {Direction::SE, Jump::SHORT}.as PieceMovement
                      when {Direction::S, 2, Direction::W, 1}
                        {Direction::SW, Jump::LONG}.as PieceMovement
                      when {Direction::S, 1, Direction::W, 2}
                        {Direction::SW, Jump::SHORT}.as PieceMovement
                      end

    if knight_movement.nil?
      raise "Could not determine Knight's movement"
    end

    return knight_movement
  end

  if is_diagonal_move
    if horizontal_diff == vertical_diff
      # for non-knights, a valid diagonal in chess is 1:1 for horizontal to
      #  vertical squares a diagonal move counts squares on the diagonal,
      # instead of combining its separate horizontal and vertical counts,
      # and because it's 1:1 horizontal to vertical the diagonal movement is same for either
      count = horizontal_diff
    else
      raise "Illegal diagonal move"
    end
  else
    # either the horizontal_diff is 0 or the vertical_diff is 0
    # since the direction if not diagonal is one along one axis,
    # and therefore the total moves can be added
    count = horizontal_diff + vertical_diff
  end

  case {vertical_direction, horizontal_direction}
  when {Direction::N, nil}
    {Direction::N, count}
  when {Direction::N, Direction::E}
    {Direction::NE, count}
  when {nil, Direction::E}
    {Direction::E, count}
  when {Direction::S, Direction::E}
    {Direction::SE, count}
  when {Direction::S, nil}
    {Direction::S, count}
  when {Direction::S, Direction::W}
    {Direction::SW, count}
  when {nil, Direction::W}
    {Direction::W, count}
  when {Direction::N, Direction::W}
    {Direction::NW, count}
  else
    raise "No direction found"
  end
end
