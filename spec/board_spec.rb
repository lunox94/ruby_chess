# frozen_string_literal: true

require './lib/board'
require './lib/serialization/fen_processor'

describe Board do
  describe '#in_check?' do
    it 'returns true when the king is in check' do
      board = FenProcessor.load('8/3k4/3p4/8/8/7B/8/3R3K w - - 0 1')
      expect(board.in_check?(Piece::BLACK)).to be true
    end

    it 'returns false when the king is not in check' do
      board = FenProcessor.load('8/3k4/3p4/8/8/8/8/3R3K w - - 0 1')
      expect(board.in_check?(Piece::BLACK)).to be false
    end
  end
end
