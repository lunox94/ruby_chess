# frozen_string_literal: true

require './lib/pieces/knight'
require './lib/serialization/fen_processor'

describe Knight do
  describe '#available_moves' do
    it 'returns all knight moves' do
      board = FenProcessor.load('8/8/2r5/1r3P2/3N4/8/2P5/8 w - - 0 1')
      knight = board.piece_at([3, 3])
      expected_moves = [[1, 4], [5, 2], [5, 4], [2, 1], [2, 5], [4, 1]]
      actual_moves = knight.available_moves(board, [3, 3])
      expect(actual_moves).to eq(expected_moves)
    end

    it 'returns all knight moves when the knight is in a corner' do
      board = FenProcessor.load('8/8/8/8/8/8/8/n7 w - - 0 1')
      knight = board.piece_at([0, 0])
      expected_moves = [[2, 1], [1, 2]]
      actual_moves = knight.available_moves(board, [0, 0])
      expect(actual_moves).to eq(expected_moves)
    end
  end
end
