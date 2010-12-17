Given /^an AI tic\-tac\-toe that has been trained for (\d+) runs$/ do |training_runs|
  player1 = TicTacToe::Player.new("X", true)
  player2 = TicTacToe::Player.new("O", true)
  @trained_player = player1
  TicTacToe::Game.train!(@trained_player, player2, training_runs.to_i)
end

# When /^when playing against an untrained player$/ do
#   @untrained_player = TicTacToe::Player.new("O", false)
# end

Then /^the AI player should not loose even once in (\d+) games$/ do |games|
  games.to_i.times do |num_try|
    untrained = TicTacToe::Player.new("O", false)
    game_report = TicTacToe::Game.new(@trained_player, untrained).play
    puts "game report[#{num_try}] - #{game_report}"
    (/X WINS !!!/ =~ game_report || /DRAW !!!/ =~ game_report).should be_true 
  end
end

Given /^an AI player using a DB$/ do
  @intelligent_player = TicTacToe::Player.new("X", true)
end

Then /^the AI player should not loose in (\d+) games against a new player$/ do |games|
  games.to_i.times do |num_try|
    untrained = TicTacToe::Player.new("O", false)
    game_report = TicTacToe::Game.new(@intelligent_player, untrained).play
    puts "game report[#{num_try}] - #{game_report}"
    (/X WINS !!!/ =~ game_report || /DRAW !!!/ =~ game_report).should be_true 
  end
  
end