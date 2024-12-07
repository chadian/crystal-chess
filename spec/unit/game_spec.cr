require "spec"
require "../../src/game"

describe "Game" do
  it "can be initialized" do
    game = Game.new
    (game.is_a? Game).should be_true
  end

  it "has a board" do
    game = Game.new
    (game.board.is_a? Board).should be_true
  end
end
