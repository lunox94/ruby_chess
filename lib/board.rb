# frozen_string_literal: true

# This class will be responsible for the board of the game.
class Board
  NUMBER_OF_ROWS = 8
  NUMBER_OF_COLUMNS = 8
  INVALID_POSITION_ERROR = 'Invalid position'

  attr_reader :grid

  def initialize
    @grid = Array.new(NUMBER_OF_ROWS) { Array.new(NUMBER_OF_COLUMNS) }
  end

  def add_piece(piece, position)
    raise INVALID_POSITION_ERROR unless valid_position?(position)

    row, col = position
    @grid[row][col] = piece
  end

  private

  def valid_position?(position)
    row, col = position
    row.between?(0, NUMBER_OF_ROWS - 1) && col.between?(0, NUMBER_OF_COLUMNS - 1)
  end
end
