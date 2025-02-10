# frozen_string_literal: true

require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/knight'
require_relative '../pieces/pawn'
require_relative '../pieces/queen'
require_relative '../pieces/rook'

# This module serves as namespace for the serialization logic.
module Serialization
  PIECE_MAP = {
    'r' => ->(color) { Rook.new(color) },
    'n' => ->(color) { Knight.new(color) },
    'b' => ->(color) { Bishop.new(color) },
    'q' => ->(color) { Queen.new(color) },
    'k' => ->(color) { King.new(color) },
    'p' => ->(color) { Pawn.new(color) }
  }.freeze

  def self.create_piece(symbol)
    piece_creator = PIECE_MAP[symbol.downcase]
    color = symbol == symbol.downcase ? Piece::BLACK : Piece::WHITE
    piece_creator&.call(color)
  end

  def self.valid_piece_char?(symbol)
    PIECE_MAP.key?(symbol.downcase)
  end
end
