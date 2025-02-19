# frozen_string_literal: true

# This class represents the state of the game at a given moment.
class GameState
  attr_reader :active_color, :board

  attr_accessor :en_passant_square, :halfmove_clock, :fullmove_number, :castling_availability

  # rubocop:disable Metrics/ParameterLists
  def initialize(board, castling_availability: {}, active_color: Piece::WHITE, en_passant_square: nil,
                 halfmove_clock: 0, fullmove_number: 1)
    @board = board
    @castling_availability = castling_availability
    @active_color = active_color
    @en_passant_square = en_passant_square
    @halfmove_clock = halfmove_clock
    @fullmove_number = fullmove_number
  end
  # rubocop:enable Metrics/ParameterLists
end
