# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Pawn
  include Piece

  UP = [1, 0].freeze
  UP_LEFT = [1, -1].freeze
  UP_RIGHT = [1, 1].freeze

  DOWN = [-1, 0].freeze
  DOWN_LEFT = [-1, -1].freeze
  DOWN_RIGHT = [-1, 1].freeze

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2659" : "\u265F"
  end

  def available_moves(board, position)
    super

    moves = []

    moves.concat(available_captures(board, position))
    moves.concat(available_moves_forward(board, position))
    moves.concat(available_moves_double_forward(board, position))
  end

  private

  def available_captures(board, position)
    captures = []

    moves = @color == Piece::WHITE ? [UP_LEFT, UP_RIGHT] : [DOWN_LEFT, DOWN_RIGHT]

    moves.each do |capture|
      next_position = advance_position(position, capture)

      next unless Board.valid_position?(next_position)

      piece = board.piece_at(next_position)

      captures << next_position if piece && piece.color != @color
    end

    captures
  end

  def available_moves_forward(board, position)
    direction = @color == Piece::WHITE ? UP : DOWN

    next_position = advance_position(position, direction)

    return [] unless Board.valid_position?(next_position)

    piece = board.piece_at(next_position)

    piece.nil? ? [next_position] : []
  end

  def available_moves_double_forward(board, position)
    initial_row = @color == Piece::WHITE ? 1 : 6
    direction = @color == Piece::WHITE ? UP : DOWN

    first_square = advance_position(position, direction)
    second_square = advance_position(first_square, direction)

    return [] if position[0] != initial_row

    board.piece_at(first_square).nil? && board.piece_at(second_square).nil? ? [second_square] : []
  end

  def advance_position(position, direction)
    [position[0] + direction[0], position[1] + direction[1]]
  end
end
