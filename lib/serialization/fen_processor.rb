# frozen_string_literal: true

require_relative '../board'
require_relative 'serialization'
require_relative '../game_state'

# This class will be responsible for serializing and deserializing the board to and from FEN.
class FenProcessor
  INVALID_FEN_ERROR = 'Invalid FEN'

  # @return [Board] the board object created from the FEN string
  def self.load(fen)
    parts = fen.split
    build_board(parts[0])
  end

  def self.build_board(piece_placement_data)
    board = Board.new

    for_each_char_in(piece_placement_data) do |char, row_index, col_index|
      next char.to_i if char.to_i.positive? # Skip empty squares

      piece = create_piece_from(char)
      position = [Board::NUMBER_OF_ROWS - row_index - 1, col_index]
      board.add_piece(piece, position)

      next 1 # Move to the next column
    end

    board
  end

  def self.create_piece_from(char)
    raise INVALID_FEN_ERROR unless Serialization.valid_piece_char?(char)

    Serialization.create_piece(char)
  end

  def self.for_each_char_in(piece_placement_data)
    piece_placement_data.split('/').each_with_index do |row, row_index|
      col_index = 0
      row.each_char do |char|
        col_index += yield char, row_index, col_index
      end
    end
  end

  def self.get_active_color(active_color)
    if active_color == 'w'
      Piece::WHITE
    elsif active_color == 'b'
      Piece::BLACK
    else
      raise INVALID_FEN_ERROR
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.get_castling_availability(castling_availability)
    response = {
      Piece::WHITE => [],
      Piece::BLACK => []
    }

    castling_availability.each_char do |char|
      case char
      when 'K'
        response[Piece::WHITE] << :kingside
      when 'Q'
        response[Piece::WHITE] << :queenside
      when 'k'
        response[Piece::BLACK] << :kingside
      when 'q'
        response[Piece::BLACK] << :queenside
      when '-'
        next
      else
        raise INVALID_FEN_ERROR
      end
    end

    response
  end
  # rubocop:enable Metrics/MethodLength

  def self.get_en_passant_target_square(en_passant_target_square)
    # TODO: Deferring implementation until we can process algebraic notation
  end

  def self.get_halfmove_clock(halfmove_clock)
    halfmove_clock.to_i
  end

  def self.get_fullmove_number(fullmove_number)
    fullmove_number.to_i
  end

  def self.parse_fen(fen)
    parts = fen.split
    board = build_board(parts[0])
    active_color = get_active_color(parts[1])
    castling = get_castling_availability(parts[2])
    en_passant = get_en_passant_target_square(parts[3])
    halfmove_clock = get_halfmove_clock(parts[4])
    fullmove_number = get_fullmove_number(parts[5])

    GameState.new(board, castling_availability: castling, active_color: active_color, en_passant_square: en_passant,
                         halfmove_clock: halfmove_clock, fullmove_number: fullmove_number)
  end
end
