# frozen_string_literal: true

require_relative 'castling_helper'

# This class represents the state of the game at a given moment.
class GameState
  DRAW = :draw
  WHITE_WON = :white_won
  BLACK_WON = :black_won
  IN_PROGRESS = :in_progress

  INVALID_MOVE_ERROR = 'Invalid move'

  attr_reader :active_color, :board, :status

  attr_accessor :en_passant_square, :halfmove_clock, :fullmove_number, :castling_availability

  include CastlingHelper

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

    return castling_rights?(@active_color, castling_side(from, to)) if attempting_castling?(from, to)

    available_moves = piece.available_moves(@board, from)

    available_moves.include?(to) && can_move_piece?(from, to, piece)
  end

  def invalid_move?(from, to)
    !valid_move?(from, to)
  end

  def make_move(from, to)
    raise INVALID_MOVE_ERROR if invalid_move?(from, to)

    if attempting_castling?(from, to)
      castle(@active_color, castling_side(from, to))
    else
      @board.move_piece(from, to)
    end

    @halfmove_clock += 1

    @fullmove_number += 1 if @active_color == Piece::BLACK

    switch_active_color

    recalculate_status
  end

  private

  def draw?
    stalemate? || @halfmove_clock >= 100
  end

  def checkmate?(color)
    return false unless @board.in_check?(color)

    cannot_move_any_piece?(color)
  end

  def stalemate?
    return false if @board.in_check?(@active_color)

    cannot_move_any_piece?(@active_color)
  end

  def switch_active_color
    @active_color = @active_color == Piece::WHITE ? Piece::BLACK : Piece::WHITE
  end

  # This method checks if a piece can move from one position to another without putting the king in check.
  def can_move_piece?(from, to, piece)
    target_piece = @board.piece_at(to)

    @board.move_piece(from, to)

    result = !@board.in_check?(piece.color)

    @board.move_piece(to, from)
    @board.add_piece(target_piece, to)

    result
  end

  def cannot_move_any_piece?(color)
    @board.each_piece do |piece, position|
      next unless piece.color == color

      return false if piece.available_moves(@board, position).any? do |move|
        can_move_piece?(position, move, piece)
      end
    end

    true
  end
end
