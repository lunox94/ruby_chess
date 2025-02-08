# frozen_string_literal: true

# The RubyChess class is used to show the main menu of the game and handle the options selected by the user.
class RubyChess
  NEW_GAME_OPTION = 1
  RESUME_GAME_OPTION = 2
  ANALYSIS_BOARD_OPTION = 3
  EXIT_OPTION = 4

  def show_options
    puts 'Welcome to RubyChess'
    main_loop
    puts 'See you soon, thanks for playing RubyChess.'
  end

  def main_loop
    loop do
      puts 'Please choose an option to start:'
      print_options
      option = gets.chomp.to_i
      handle_option(option)
      break if exit_selected?(option)
    end
  end

  def print_options
    puts "#{NEW_GAME_OPTION}. New game"
    puts "#{RESUME_GAME_OPTION}. Resume game"
    puts "#{ANALYSIS_BOARD_OPTION}. Analysis board"
    puts "#{EXIT_OPTION}. Exit"
  end

  def handle_option(option)
    case option
    when NEW_GAME_OPTION
      puts 'Starting a new game...'
      # ...handle new game logic...
    when RESUME_GAME_OPTION
      puts 'Resuming game...'
      # ...handle resume game logic...
    when ANALYSIS_BOARD_OPTION
      puts 'Opening analysis board...'
      # ...handle analysis board logic...
    when EXIT_OPTION
      puts 'Exiting...'
    else
      puts 'Invalid option, please try again.'
    end
  end

  def exit_selected?(option)
    option == EXIT_OPTION
  end
end

RubyChess.new.show_options
