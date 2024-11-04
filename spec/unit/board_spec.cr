require "spec"
require "../../src/board"

describe "#convert_board_coordinate_to_array_matrix_coordinate" do
  it "converts a BoardCoordinate to an ArrayMatrixCoordinate (bottom left coordinate)" do
    array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate({'a', 1})
    array_matrix_coordinate.should eq({7, 0})
  end

  it "converts a BoardCoordinate to an ArrayMatrixCoordinate (bottom right coordinate)" do
    array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate({'h', 1})
    array_matrix_coordinate.should eq({7, 7})
  end

  it "converts a BoardCoordinate to an ArrayMatrixCoordinate (top left coordinate)" do
    array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate({'a', 8})
    array_matrix_coordinate.should eq({0, 0})
  end

  it "converts a BoardCoordinate to an ArrayMatrixCoordinate (top right coordinate)" do
    array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate({'h', 8})
    array_matrix_coordinate.should eq({0, 7})
  end

  it "raises an exception for an invalid rank coordinate" do
    expect_raises(Exception) do
      array_matrix_coordinate = convert_board_coordinate_to_array_matrix_coordinate({'h', 9})
    end
  end
end

describe "create_movement" do
  describe "movements on prime axes" do
    it "creates a PieceMovement from two `BoardCoordinates` (north movement)" do
      (create_movement({'d', 1}, {'d', 8})).should eq({Direction::N, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south movement)" do
      (create_movement({'d', 8}, {'d', 1})).should eq({Direction::S, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (east movement)" do
      (create_movement({'a', 4}, {'h', 4})).should eq({Direction::E, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (west movement)" do
      (create_movement({'h', 4}, {'a', 4})).should eq({Direction::W, 7})
    end
  end

  describe "movements on diagonal axes" do
    it "creates a PieceMovement from two `BoardCoordinates` (north east movement)" do
      (create_movement({'a', 1}, {'h', 8})).should eq({Direction::NE, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south west movement)" do
      (create_movement({'h', 8}, {'a', 1})).should eq({Direction::SW, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (east movement)" do
      (create_movement({'a', 8}, {'h', 1})).should eq({Direction::SE, 7})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (west movement)" do
      (create_movement({'h', 1}, {'a', 8})).should eq({Direction::NW, 7})
    end
  end

  describe "jump movements" do
    it "creates a PieceMovement from two `BoardCoordinates` (north east, long)" do
      (create_movement({'d', 4}, {'e', 6})).should eq({Direction::NE, Jump::LONG})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (north east, short)" do
      (create_movement({'d', 4}, {'f', 5})).should eq({Direction::NE, Jump::SHORT})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south east, long)" do
      (create_movement({'d', 4}, {'e', 2})).should eq({Direction::SE, Jump::LONG})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south east, short)" do
      (create_movement({'d', 4}, {'f', 3})).should eq({Direction::SE, Jump::SHORT})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south west, long)" do
      (create_movement({'d', 4}, {'c', 2})).should eq({Direction::SW, Jump::LONG})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (south west, short)" do
      (create_movement({'d', 4}, {'b', 3})).should eq({Direction::SW, Jump::SHORT})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (north west, long)" do
      (create_movement({'d', 4}, {'c', 6})).should eq({Direction::NW, Jump::LONG})
    end

    it "creates a PieceMovement from two `BoardCoordinates` (north west, short)" do
      (create_movement({'d', 4}, {'b', 5})).should eq({Direction::NW, Jump::SHORT})
    end
  end
end
