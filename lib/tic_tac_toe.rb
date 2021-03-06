module TicTacToe
  X = "X"
  O = "O"
  TOKENS = [X, O]
  
  autoload :Game,   'tic_tac_toe/game'
  autoload :Player, 'tic_tac_toe/player'
  autoload :Board,  'tic_tac_toe/board'
  autoload :CLI,    'tic_tac_toe/cli'
end