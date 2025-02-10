# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Queen
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2655" : "\u265B"
  end

  def available_moves
    # Implement the logic for available moves for a Queen
  end
end
