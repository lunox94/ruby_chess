# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Knight
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2658" : "\u265E"
  end

  def available_moves
    # Implement the logic for available moves for a Knight
  end
end
