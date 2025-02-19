# frozen_string_literal: true

describe FenProcessor do
  describe '.parse_fen' do
    context 'when the FEN string is valid' do
      fen = 'r3k2r/7p/8/8/5P2/4N3/P7/R3K2R w KQk - 3 11'
      game_state = described_class.parse_fen(fen)

      it 'returns the board object' do
        # Check the board has the correct pieces
        expected_pieces = get_expected_pieces

        expected_pieces.each do |position, piece_class|
          expect(game_state.board.piece_at(position)).to be_an_instance_of(piece_class)
        end
      end

      it 'returns the correct active color' do
        expect(game_state.active_color).to eq(Piece::WHITE)
      end

      it 'returns the correct castling availability for white' do
        expect(game_state.castling_availability[Piece::WHITE]).to eq(%i[kingside queenside])
      end

      it 'returns the correct castling availability for black' do
        expect(game_state.castling_availability[Piece::BLACK]).to eq(%i[kingside])
      end

      it 'returns the correct halfmove clock' do
        expect(game_state.halfmove_clock).to eq(3)
      end

      it 'returns the correct fullmove number' do
        expect(game_state.fullmove_number).to eq(11)
      end
    end

    context 'when the FEN string is invalid' do
      it 'raises an error' do
        fen = 'invalid_fen'
        expect { described_class.parse_fen(fen) }.to raise_error(FenProcessor::INVALID_FEN_ERROR)
      end
    end
  end
end

# rubocop:disable Metrics/MethodLength
# rubocop:disable Naming/AccessorMethodName
def get_expected_pieces
  {
    [0, 0] => Rook,
    [0, 7] => Rook,
    [7, 0] => Rook,
    [7, 7] => Rook,
    [0, 4] => King,
    [7, 4] => King,
    [1, 0] => Pawn,
    [3, 5] => Pawn,
    [6, 7] => Pawn,
    [2, 4] => Knight
  }.freeze
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Naming/AccessorMethodName
