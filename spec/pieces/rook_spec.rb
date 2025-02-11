# frozen_string_literal: true

require './lib/pieces/rook'
require './lib/serialization/fen_processor'

describe Rook do
  # Add tests for Rook's movements
  describe '#available_moves' do
    board = FenProcessor.load('8/3p4/8/1P1R2p1/8/3P4/8/8 w - - 0 1')

    it 'returns the correct available moves for the rook' do
      rook = board.piece_at([4, 3])
      expected_moves = [[5, 3], [6, 3], [3, 3], [4, 2], [4, 4], [4, 5], [4, 6]]
      actual_moves = rook.available_moves(board, [4, 3])
      expect(actual_moves).to eq(expected_moves)
    end
  end
end
