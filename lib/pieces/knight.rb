# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Knight
  include Piece

  MOVES = [
    [-2, -1], [-2, 1], [2, -1], [2, 1],
    [-1, -2], [-1, 2], [1, -2], [1, 2]
  ].freeze

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2658" : "\u265E"
  end

  def available_moves(board, position)
    moves = []

    MOVES.each do |move|
      next_position = advance_position(position, move)

      next unless Board.valid_position?(next_position)

      piece = board.piece_at(next_position)

      moves << next_position if piece.nil? || piece.color != @color
    end

    moves
  end

  private

  def advance_position(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end
end
