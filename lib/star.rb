# frozen_string_literal: true

# This class is used to represent a Star in the game.
class Star
  include HasSymbol

  def initialize
    @symbol = '*'
  end
end
