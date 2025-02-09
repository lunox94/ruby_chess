# frozen_string_literal: true

# This class will be responsible for the board of the game.
class Board
  NUMBER_OF_ROWS = 8
  NUMBER_OF_COLUMNS = 8

  attr_reader :board

  def initialize
    @board = Array.new(NUMBER_OF_ROWS) { Array.new(NUMBER_OF_COLUMNS) }
  end
end
