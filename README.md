# TODO list
- When making a move, update castling rights
- En passant logic
- When making a move, update the halfmove clock properly
- Improve the game cli, e.g. resume game should read a fen from input
- Enable subcommands when querying moves to the user, now users enter a move: e2e4, addtionally allowing the following commands is desired:
    - :show_moves e2
    - :quit
Quit will output the fen representing the current game state.