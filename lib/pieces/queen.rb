# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Queen
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
    @symbol = color == :white ? "\u2655" : "\u265B"
  end

  def available_moves(board, position)
    super

    moves = []

    MOVES.each do |move|
      moves.concat(available_moves_in_direction(board, position, move))
    end

    moves
  end

  private

  def advance_position(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end

  def available_moves_in_direction(board, position, direction)
    moves = []
    current_position = position

    loop do
      current_position = advance_position(current_position, direction)

      break unless Board.valid_position?(current_position)

      piece = board.piece_at(current_position)

      moves << current_position if piece.nil? || piece.color != color

      break if piece
    end

    moves
  end
end
