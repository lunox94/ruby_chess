# frozen_string_literal: true

require_relative '../graphics'

# This class is responsible for the analysis board of the game.
class AnalysisBoard
  ADD_PIECE_OPTION = 1
  REMOVE_PIECE_OPTION = 2
  MOVE_PIECE_OPTION = 3
  SHOW_AVAILABLE_MOVES_OPTION = 4
  EXIT_OPTION = 5

  def initialize(board)
    @board = board
  end

  def show_options
    main_loop
  end

  private

  def clear_and_show_board
    Graphics.clear
    Graphics.display(@board.grid)
  end

  def exit_selected?(option)
    option == EXIT_OPTION
  end

  def handle_option(option)
    case option
    when ADD_PIECE_OPTION
      @message = 'Adding a piece...'

    when REMOVE_PIECE_OPTION
      puts 'Removing a piece...'

    when MOVE_PIECE_OPTION
      puts 'Moving a piece...'

    when SHOW_AVAILABLE_MOVES_OPTION
      puts 'Showing available moves...'

    when EXIT_OPTION
      puts 'Exiting analysis board...'
    else
      puts 'Invalid option, please try again.'
    end
  end

  def main_loop
    loop do
      clear_and_show_board
      show_message_if_any

      option = print_and_handle_options
      break if exit_selected?(option)
    end
  end

  def print_and_handle_options
    puts 'Please choose an option:'
    print_options
    option = gets.chomp.to_i
    handle_option(option)
    option
  end

  def print_options
    puts "#{ADD_PIECE_OPTION}. Add piece"
    puts "#{REMOVE_PIECE_OPTION}. Remove piece"
    puts "#{MOVE_PIECE_OPTION}. Move piece"
    puts "#{SHOW_AVAILABLE_MOVES_OPTION}. Show available moves for a piece"
    puts "#{EXIT_OPTION}. Exit"
  end

  def show_message_if_any
    puts @message if @message
  end
end
