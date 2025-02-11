# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Rook piece in the game.
class Rook
  include Piece

  UP = [1, 0].freeze
  DOWN = [-1, 0].freeze
  LEFT = [0, -1].freeze
  RIGHT = [0, 1].freeze

  MOVES = [UP, DOWN, LEFT, RIGHT].freeze

  VERTICAL = [UP, DOWN].freeze
  HORIZONTAL = [LEFT, RIGHT].freeze

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2656" : "\u265C"
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

  def advance_position(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end
end
