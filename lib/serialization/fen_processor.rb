# frozen_string_literal: true

require_relative '../board'
require_relative 'serialization'

# This class will be responsible for serializing and deserializing the board to and from FEN.
class FenProcessor
  INVALID_FEN_ERROR = 'Invalid FEN'

  # @return [Board] the board object created from the FEN string
  def self.load(fen)
    board = Board.new
    rows = fen.split('/')
    rows.each_with_index do |row, row_index|
      col_index = 0
      row.each_char do |char|
        if char.to_i.positive?
          col_index += char.to_i
          next
        end

        raise INVALID_FEN_ERROR unless Serialization.valid_piece_char?(char)

        piece = Serialization.create_piece(char)
        position = [row_index, col_index]
        board.add_piece(piece, position)
        col_index += 1
      end
    end
    board
  end
end
