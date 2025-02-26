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

  def castle(color, side)
    rook_position = rook_starting_position(color, side)
    king_position = king_starting_position(color)

    if side == :queenside
      @board.move_piece(king_position, [king_position[0], 2])
      @board.move_piece(rook_position, [rook_position[0], 3])
    else
      @board.move_piece(king_position, [king_position[0], 6])
      @board.move_piece(rook_position, [rook_position[0], 5])
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
    castling_side(from, to) != nil
  end

  def castling_rights?(color, side)
    return false unless %i[kingside queenside].include?(side)

    castling_availability?(color, side)
  end

  def castling_side(from, to)
    case [from, to]
    in WHITE_CASTLE_KINGSIDE_MOVESET | BLACK_CASTLE_KINGSIDE_MOVESET then :kingside
    in WHITE_CASTLE_QUEENSIDE_MOVESET | BLACK_CASTLE_QUEENSIDE_MOVESET then :queenside
    else nil
    end
  end

  def castling_availability?(color, side)
    return false unless pieces_well_placed_for_castling?(color, side)

    return false unless @castling_availability[color].include?(side)

    return false unless no_pieces_between_king_and_rook?(color, side)

    return false unless no_squares_attacked_between_king_and_rook?(color, side)

    true
  end

  def pieces_well_placed_for_castling?(color, side)
    king = @board.piece_at(king_starting_position(color))
    rook = @board.piece_at(rook_starting_position(color, side))

    return false unless king.is_a?(King) && king.color == color

    return false unless rook.is_a?(Rook) && rook.color == color

    true
  end

  def no_pieces_between_king_and_rook?(color, side)
    king_position = king_starting_position(color)

    side_positions_offset = side == :queenside ? [-1, -2] : [1]

    side_positions_offset.each do |offset|
      return false if @board.piece_at([king_position[0], king_position[1] + offset])
    end

    true
  end

  def no_squares_attacked_between_king_and_rook?(color, side)
    king_position = king_starting_position(color)
    opposing_color = color == Piece::WHITE ? Piece::BLACK : Piece::WHITE

    side_positions_offset = side == :queenside ? [0, -1, -2] : [0, 1]

    side_positions_offset.each do |offset|
      return false if @board.square_controlled?(opposing_color, [king_position[0], king_position[1] + offset])
    end

    true
  end

  def king_starting_position(color)
    color == Piece::WHITE ? [0, 4] : [7, 4]
  end

  def rook_starting_position(color, side)
    row = color == Piece::WHITE ? 0 : 7

    side == :queenside ? [row, 0] : [row, 7]
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
