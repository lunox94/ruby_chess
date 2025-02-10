# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Bishop piece in the game.
class Bishop
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2657" : "\u265D"
  end

  def available_moves
    # Implement the logic for available moves for a Bishop
  end
end
