# frozen_string_literal: true

require './lib/pieces/queen'
require './lib/serialization/fen_processor'

describe Queen do
  describe '#available_moves' do
    board = FenProcessor.load('8/3r4/1p6/8/P2Q4/8/1N3P2/8 w - - 0 1')

    it 'returns all available moves for the queen' do
      queen = board.piece_at([3, 3])
      expected_moves = [[4, 3], [5, 3], [6, 3], [2, 3], [1, 3], [0, 3], [3, 2], [3, 1], [3, 4], [3, 5], [3, 6], [3, 7],
                        [2, 2], [4, 4], [5, 5], [6, 6], [7, 7], [2, 4], [4, 2], [5, 1]]
      actual_moves = queen.available_moves(board, [3, 3])
      expect(actual_moves).to eq(expected_moves)
    end
  end
end
