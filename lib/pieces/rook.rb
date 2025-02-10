# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Rook piece in the game.
class Rook
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2656" : "\u265C"
  end

  def available_moves
    # Implement the logic for available moves for a Rook
  end
end
