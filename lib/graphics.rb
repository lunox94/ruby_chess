# frozen_string_literal: true

# This class is responsible for displaying the board on the console.
class Graphics
  def self.display(board)
    board.each_with_index do |row, row_index|
      row_display = row.map.with_index do |square, col_index|
        if (row_index + col_index).odd?
          square.nil? ? "\u25A0" : square # Black square
        else
          square.nil? ? "\u25A1" : square # White square
        end
      end
      puts row_display.join(' ')
    end
  end

  def self.clear
    system('clear') || system('cls')
  end
end
