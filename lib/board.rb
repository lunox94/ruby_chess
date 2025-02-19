# frozen_string_literal: true

# This class will be responsible for the board of the game.
class Board
  NUMBER_OF_ROWS = 8
  NUMBER_OF_COLUMNS = 8
  NO_KING_FOUND_ERROR = 'No king found'
  INVALID_POSITION_ERROR = 'Invalid position'

  attr_reader :grid

  def initialize
    @grid = Array.new(NUMBER_OF_ROWS) { Array.new(NUMBER_OF_COLUMNS) }
  end

  def add_piece(piece, position)
    raise INVALID_POSITION_ERROR unless self.class.valid_position?(position)

    row, col = position
    @grid[row][col] = piece
  end

  def in_check?(color)
    king_position = nil

    each_piece do |piece, position|
      next unless piece.color == color && piece.is_a?(King)

      king_position = position
      break
    end

    raise NO_KING_FOUND_ERROR if king_position.nil?

    square_controlled?(color == Piece::WHITE ? Piece::BLACK : Piece::WHITE, king_position)
  end

  def piece_at(position)
    raise INVALID_POSITION_ERROR unless self.class.valid_position?(position)

    row, col = position
    @grid[row][col]
  end

  def square_controlled?(color, target)
    raise INVALID_POSITION_ERROR unless self.class.valid_position?(target)

    each_piece do |piece, position|
      next if piece.color != color

      return true if piece.available_moves(self, position).include?(target)
    end

    false
  end

  def each_piece
    NUMBER_OF_ROWS.times do |row|
      NUMBER_OF_COLUMNS.times do |col|
        piece = @grid[row][col]
        yield(piece, [row, col]) if piece
      end
    end
  end

  def self.valid_position?(position)
    row, col = position
    row.between?(0, NUMBER_OF_ROWS - 1) && col.between?(0, NUMBER_OF_COLUMNS - 1)
  end
end
