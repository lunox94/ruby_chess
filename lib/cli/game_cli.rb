# frozen_string_literal: true

require_relative '../graphics'
require_relative '../serialization/fen_processor'

class GameCli
  NEW_GAME_OPTION = 1
  RESUME_GAME_OPTION = 2
  EXIT_OPTION = 3

  NEW_GAME_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

  def start
    main_loop
  end

  private

  def exit_selected?(option)
    option == EXIT_OPTION
  end

  def handle_option(option)
    case option
    when NEW_GAME_OPTION
      puts 'Starting a new game...'
      @game = FenProcessor.parse_fen(NEW_GAME_FEN)

      while @game.status == GameState::IN_PROGRESS
        clear_and_show_board(@game.board.grid)

        move = obtain_move

        @game.make_move(move[0], move[1])

        if @game.status == GameState::WHITE_WON
          puts 'White has won the game!'
        elsif @game.status == GameState::BLACK_WON
          puts 'Black has won the game!'
        end
      end

    when RESUME_GAME_OPTION
      puts 'Resuming game...'
      # ...handle resume game logic...
    when EXIT_OPTION
      puts 'Closing game...'
    else
      puts 'Invalid option, please try again.'
    end
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
    puts "#{EXIT_OPTION}. Exit"
  end

  def obtain_move
    move = []

    while move.empty?
      puts "#{player_name_from_game_state} to play. Enter your move (e.g. e2e4):"
      move = parse_move(gets.chomp)

      if move.empty? || @game.invalid_move?(move[0], move[1])
        move = []
        puts 'Invalid move, please try again.'
      end
    end

    move
  end

  def parse_move(raw_move)
    p(raw_move)
    move = raw_move.strip
    move.downcase!

    return [] unless move.match?(/^[a-h][1-8][a-h][1-8]$/)

    [parse_position(move[0..1]), parse_position(move[2..3])]
  end

  def parse_position(position)
    [position[1].to_i - 1, position[0].ord - 'a'.ord]
  end

  def clear_and_show_board(board)
    Graphics.clear
    Graphics.display(board)
  end

  def player_name_from_game_state
    @game.active_color == Piece::WHITE ? 'White' : 'Black'
  end
end
