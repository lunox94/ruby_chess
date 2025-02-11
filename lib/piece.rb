# frozen_string_literal: true

require_relative 'has_symbol'

# This module is used to define the color and symbol of a piece.
module Piece
  include HasSymbol

  BLACK = :black
  WHITE = :white

  INVALID_PIECE_REFERENCE_ERROR = 'Invalid piece reference, the piece does not exist in the board for
  the given position.'

  attr_reader :color

  def available_moves(board, position)
    raise INVALID_PIECE_REFERENCE_ERROR unless board.piece_at(position) == self

    []
  end
end
