# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a King piece in the game.
class King
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2654" : "\u265A"
  end

  def available_moves
    # Implement the logic for available moves for a King
  end
end
