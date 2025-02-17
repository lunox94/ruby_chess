# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a King piece in the game.
class King
  include Piece

  UP = [1, 0].freeze
  DOWN = [-1, 0].freeze
  LEFT = [0, -1].freeze
  RIGHT = [0, 1].freeze
  UP_LEFT = [-1, -1].freeze
  DOWN_RIGHT = [1, 1].freeze
  UP_RIGHT = [-1, 1].freeze
  DOWN_LEFT = [1, -1].freeze

  MOVES = [UP, DOWN, LEFT, RIGHT, UP_LEFT, DOWN_RIGHT, UP_RIGHT, DOWN_LEFT].freeze

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2654" : "\u265A"
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

  def advance_position(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end
end
