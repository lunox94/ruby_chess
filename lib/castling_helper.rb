# frozen_string_literal: true

# This module will be responsible for the castling logic.
module CastlingHelper
  BLACK_CASTLE_KINGSIDE_MOVESET = [[7, 4], [7, 6]].freeze
  BLACK_CASTLE_QUEENSIDE_MOVESET = [[7, 4], [7, 2]].freeze
  WHITE_CASTLE_KINGSIDE_MOVESET = [[0, 4], [0, 6]].freeze
  WHITE_CASTLE_QUEENSIDE_MOVESET = [[0, 4], [0, 2]].freeze

  def attempting_castling?(from, to)
    castling_side(from, to) != nil
  end

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

  def castling_availability?(color, side)
    return false unless pieces_well_placed_for_castling?(color, side)

    return false unless @castling_availability[color].include?(side)

    return false unless no_pieces_between_king_and_rook?(color, side)

    return false unless no_squares_attacked_between_king_and_rook?(color, side)

    true
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

  def king_starting_position(color)
    color == Piece::WHITE ? [0, 4] : [7, 4]
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

  def pieces_well_placed_for_castling?(color, side)
    king = @board.piece_at(king_starting_position(color))
    rook = @board.piece_at(rook_starting_position(color, side))

    return false unless king.is_a?(King) && king.color == color

    return false unless rook.is_a?(Rook) && rook.color == color

    true
  end

  def rook_starting_position(color, side)
    row = color == Piece::WHITE ? 0 : 7

    side == :queenside ? [row, 0] : [row, 7]
  end
end
