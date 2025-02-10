# frozen_string_literal: true

require_relative '../piece'

# This class is used to represent a Knight piece in the game.
class Pawn
  include Piece

  def initialize(color)
    @color = color
    @symbol = color == :white ? "\u2659" : "\u265F"
  end

  def available_moves
    # Implement the logic for available moves for a Pawn
  end
end
