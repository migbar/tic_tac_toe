Given /^a trained tic\-tac\-toe AI player for (\d+) runs$/ do |runs|
  @player = TicTacToe::Player.new
  TicTacToe.train!(@player, TicTacToe::Player.new, runs)
end