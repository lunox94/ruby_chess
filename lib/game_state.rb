# frozen_string_literal: true

# This class represents the state of the game at a given moment.
class GameState
  DRAW = :draw
  WHITE_WON = :white_won
  BLACK_WON = :black_won
  IN_PROGRESS = :in_progress

  attr_reader :active_color, :board, :status

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

    recalculate_status
  end
  # rubocop:enable Metrics/ParameterLists

  def recalculate_status
    return @status = DRAW if draw?
    return @status = WHITE_WON if checkmate?(Piece::BLACK)
    return @status = BLACK_WON if checkmate?(Piece::WHITE)

    @status = IN_PROGRESS
  end

  def valid_move?(from, to)
    piece = @board.piece_at(from)

    return false if piece.nil? || piece.color != @active_color

    available_moves = piece.available_moves(@board, from)

    available_moves.include?(to)
  end

  def invalid_move?(from, to)
    !valid_move?(from, to)
  end

  def make_move(from, to)
    @board.move_piece(from, to)

    @halfmove_clock += 1

    @fullmove_number += 1 if @active_color == Piece::BLACK

    switch_active_color

    recalculate_status
  end

  private

  def draw?
    false
  end

  def checkmate?(color)
    false
  end

  def switch_active_color
    @active_color = @active_color == Piece::WHITE ? Piece::BLACK : Piece::WHITE
  end
end
