require 'rubygems'
require 'commander'



# :name is optional, otherwise uses the basename of this executable
program :name, 'Tic Tac Toe'
program :version, '0.0.1'
program :description, 'Artificically Intelligent Tic-Tac-Toe.'


# choose("do you want to train a player or play a game?:") do |menu|
#   menu.index = :number
#   menu.index_suffix = ") "
#   menu.prompt = "Please choose an action:  "
#   menu.choice :train do 
#     rounds = ask("how many rounds do you want to train the player for?: (between 1 and 10,000) ", Integer) do |q| 
#        q.in = 1..10000 
#     end
#     # puts "rounds are #{rounds}"
#   end
#   menu.choice :play  do 
#     say("Not from around here, are you?") 
#   end
# end

# command :train do 
# 
#   # puts "rounds are #{rounds}"
# end

# uris = %w[
#     http://vision-media.ca
#     http://google.com
#     http://yahoo.com
#     ]
#   numbers = 1..10000 
#   progress numbers.to_a do |uri|
#     # res = open uri
#     10000.times{|n| n+1}
#     # Do something with response
#   end
  
command :train do|c|
  c.description = 'Train a Tic-Tac-Toe player'

  c.when_called do|args, options|
    rounds = ask("how many rounds do you want to train the player for?: (between 1 and 10,000) ", Integer) do |q| 
       q.in = 1..10000 
    end
    
    progress (1..rounds).to_a do |uri|
      # training call goes here
      rounds.times{|n|
        TicTacToe::Game.play
      }
    end
    say("#{rounds} rounds of training completed.")
    wants_to_play = agree("do you want to play?") 
    if wants_to_play
      say("ok lets play !!")
    else
      say("fine, be that way. Good bye!")
    end
  end

end


# command :train do|c|
#   c.syntax = 'train [options]'
#   c.description = 'Display bar with optional prefix and suffix'
#   c.option '--rounds STRING', String, 'the number of rounds to train for'
# 
#   c.when_called do|args, options|
#     puts options.inspect
#     options.default :prefix => '(', :suffix => ')'
#     say "#{options.prefix}bar#{options.suffix}"
#     
#   end
# 
# end


# loop do
#   choose("nil") do |menu|
#     menu.layout = :menu_only
#     menu.shell = true
#     menu.choice(:load, "Load a file.") do |command, details|
#       say("Loading file with options:  #{details}...")
#     end
#     menu.choice(:save, "Save a file.") do |command, details|
#       say("Saving file with options:  #{details}...")
#     end
#     menu.choice(:quit, "Exit program.") { exit }
#   end
# end