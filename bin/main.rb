# frozen_string_literal: true

EXIT_OPTION = 4

def show_options
  puts 'Welcome to RubyChess'

  loop do
    puts 'Please choose an option to start:'

    print_options

    option = gets.chomp.to_i

    break if exit_selected?(option)
  end

  puts 'See you soon, thanks for playing RubyChess.'
end

def print_options
  puts '1. New game'
  puts '2. Resume game'
  puts '3. Analysis board'
  puts "#{EXIT_OPTION}. Exit"
end

def exit_selected?(option)
  option == EXIT_OPTION
end

show_options
