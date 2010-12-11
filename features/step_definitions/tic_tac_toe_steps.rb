Given /^an AI tic\-tac\-toe that has been trained for (\d+) runs$/ do |training_runs|
  @trained_player = TicTacToe::Player.new("X")
  TicTacToe::Game.train!(@trained_player, TicTacToe::Player.new("O"), training_runs.to_i)
end

When /^when playing against an untrained player$/ do
  @untrained_player = TicTacToe::Player.new("O")
end

Then /^the AI player should not loose even once in (\d+) games$/ do |games|
  games.to_i.times do |num_try|
    untrained = TicTacToe::Player.new("O")
    game_report = TicTacToe::Game.new(@trained_player, untrained).play
    puts "game report[#{num_try}] - #{game_report}"
    begin
      (/X WINS !!!/ =~ game_report || /DRAW !!!/ =~ game_report).should be_true 
    rescue
      puts "*"*80
      puts "*"*80
      puts "trained player"
      puts "*"*80
      puts "*"*80
      puts @trained_player.instance_variable_get("@knowledge").inspect
      
      puts "*"*80
      puts "*"*80
      puts "UNTRAINED player"
      puts "*"*80
      puts "*"*80
      puts untrained.instance_variable_get("@knowledge").inspect
      
      throw "foo"
      
    end
  end
end