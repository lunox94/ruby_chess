# frozen_string_literal: true

# This class is responsible for displaying the board on the console.
class Graphics
  def self.display(board)
    board.reverse.each_with_index do |row, row_index|
      row_display = row.map.with_index do |square, col_index|
        if square
          square.symbol
        else
          (row_index + col_index).odd? ? "\u25A0" : "\u25A1"
        end
      end
      puts row_display.join(' ')
    end
  end

  def self.clear
    system('clear') || system('cls')
  end
end
