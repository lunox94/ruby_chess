# frozen_string_literal: true

# This class represents the state of the game at a given moment.
class GameState
  DRAW = :draw
  WHITE_WON = :white_won
  BLACK_WON = :black_won
  IN_PROGRESS = :in_progress

  INVALID_MOVE_ERROR = 'Invalid move'

  BLACK_CASTLE_KINGSIDE_MOVESET = [[7, 4], [7, 6]].freeze
  BLACK_CASTLE_QUEENSIDE_MOVESET = [[7, 4], [7, 2]].freeze
  WHITE_CASTLE_KINGSIDE_MOVESET = [[0, 4], [0, 6]].freeze
  WHITE_CASTLE_QUEENSIDE_MOVESET = [[0, 4], [0, 2]].freeze

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

    return have_castling_rights?(from, to) if attempting_castling?(from, to)

    available_moves = piece.available_moves(@board, from)

    available_moves.include?(to) && can_move_piece?(from, to, piece)
  end

  def invalid_move?(from, to)
    !valid_move?(from, to)
  end

  def make_move(from, to)
    raise INVALID_MOVE_ERROR if invalid_move?(from, to)

    if attempting_castling?(from, to)
      castle(from, to)
    else
      @board.move_piece(from, to)
    end

    @halfmove_clock += 1

    @fullmove_number += 1 if @active_color == Piece::BLACK

    switch_active_color

    recalculate_status
  end

  private

  def castle(from, to)
    case [from, to]
    when WHITE_CASTLE_KINGSIDE_MOVESET
      @board.move_piece([0, 4], [0, 6])
      @board.move_piece([0, 7], [0, 5])
    when WHITE_CASTLE_QUEENSIDE_MOVESET
      @board.move_piece([0, 4], [0, 2])
      @board.move_piece([0, 0], [0, 3])
    when BLACK_CASTLE_KINGSIDE_MOVESET
      @board.move_piece([7, 4], [7, 6])
      @board.move_piece([7, 7], [7, 5])
    when BLACK_CASTLE_QUEENSIDE_MOVESET
      @board.move_piece([7, 4], [7, 2])
      @board.move_piece([7, 0], [7, 3])
    end
  end

  def draw?
    stalemate? || @halfmove_clock >= 100
  end

  def checkmate?(color)
    return false unless @board.in_check?(color)

    cannot_move_any_piece?(color)
  end

  def attempting_castling?(from, to)
    white_castling = [from, to] == WHITE_CASTLE_KINGSIDE_MOVESET || [from, to] == WHITE_CASTLE_QUEENSIDE_MOVESET
    black_castling = [from, to] == BLACK_CASTLE_KINGSIDE_MOVESET || [from, to] == BLACK_CASTLE_QUEENSIDE_MOVESET

    white_castling || black_castling
  end

  def have_castling_rights?(from, to)
    case [from, to]
    when WHITE_CASTLE_KINGSIDE_MOVESET
      check_white_kingside_castling
    when WHITE_CASTLE_QUEENSIDE_MOVESET
      check_white_queenside_castling
    when BLACK_CASTLE_KINGSIDE_MOVESET
      check_black_kingside_castling
    when BLACK_CASTLE_QUEENSIDE_MOVESET
      check_black_queenside_castling
    else
      false
    end
  end

  def check_white_kingside_castling
    king = @board.piece_at([0, 4])
    rook = @board.piece_at([0, 7])

    return false unless king.is_a?(King) && king.color == Piece::WHITE

    return false unless rook.is_a?(Rook) && rook.color == Piece::WHITE

    return false unless @castling_availability[Piece::WHITE].include?(:kingside)

    return false unless @board.piece_at([0, 5]).nil? && @board.piece_at([0, 6]).nil?

    [[0, 5], [0, 6]].each do |position|
      return false if @board.piece_at(position)
    end

    [[0, 4], [0, 5], [0, 6]].each do |position|
      return false if @board.square_controlled?(Piece::BLACK, position)
    end

    true
  end

  def check_white_queenside_castling
    king = @board.piece_at([0, 4])
    rook = @board.piece_at([0, 0])

    return false unless king.is_a?(King) && king.color == Piece::WHITE

    return false unless rook.is_a?(Rook) && rook.color == Piece::WHITE

    return false unless @castling_availability[Piece::WHITE].include?(:queenside)

    return false unless @board.piece_at([0, 1]).nil? && @board.piece_at([0, 2]).nil? && @board.piece_at([0, 3]).nil?

    [[0, 2], [0, 3]].each do |position|
      return false if @board.piece_at(position)
    end

    [[0, 2], [0, 3], [0, 4]].each do |position|
      return false if @board.square_controlled?(Piece::BLACK, position)
    end

    true
  end

  def check_black_kingside_castling
    king = @board.piece_at([7, 4])
    rook = @board.piece_at([7, 7])

    return false unless king.is_a?(King) && king.color == Piece::BLACK

    return false unless rook.is_a?(Rook) && rook.color == Piece::BLACK

    return false unless @castling_availability[Piece::BLACK].include?(:kingside)

    return false unless @board.piece_at([7, 5]).nil? && @board.piece_at([7, 6]).nil?

    [[7, 5], [7, 6]].each do |position|
      return false if @board.piece_at(position)
    end

    [[7, 4], [7, 5], [7, 6]].each do |position|
      return false if @board.square_controlled?(Piece::WHITE, position)
    end

    true
  end

  def check_black_queenside_castling
    king = @board.piece_at([7, 4])
    rook = @board.piece_at([7, 0])

    return false unless king.is_a?(King) && king.color == Piece::BLACK

    return false unless rook.is_a?(Rook) && rook.color == Piece::BLACK

    return false unless @castling_availability[Piece::BLACK].include?(:queenside)

    return false unless @board.piece_at([7, 1]).nil? && @board.piece_at([7, 2]).nil? && @board.piece_at([7, 3]).nil?

    [[7, 2], [7, 3]].each do |position|
      return false if @board.piece_at(position)
    end

    [[7, 2], [7, 3], [7, 4]].each do |position|
      return false if @board.square_controlled?(Piece::WHITE, position)
    end

    true
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
