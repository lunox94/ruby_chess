# frozen_string_literal: true

require './lib/pieces/bishop'
require './lib/serialization/fen_processor'

describe Bishop do
  describe '#available_moves' do
    board = FenProcessor.load('r7/1p3P2/8/3B4/8/8/6P1/8 w - - 0 1')

    it 'returns all diagonal moves for the bishop' do
      bishop = board.piece_at([4, 3])
      expected_moves = [[3, 2], [2, 1], [1, 0], [5, 4], [3, 4], [2, 5], [5, 2], [6, 1]]
      actual_moves = bishop.available_moves(board, [4, 3])
      expect(actual_moves).to eq(expected_moves)
    end
  end
end
