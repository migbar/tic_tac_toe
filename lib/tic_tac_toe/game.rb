module TicTacToe
  class Game
    attr_reader :player1, :player2
    
    def self.train!(player1, player2, rounds)
      rounds.times do
        play(player1, player2)
      end
    end

    def self.play(player1, player2)
      game = Game.new(player1 ,player2)
      game.play
    end
    
    def initialize(player1, player2)
      @player1, @player2 = player1, player2
      @board = Board.new
    end
    
    def play
      play_round while winner.nil?
    end
    
    def play_round
      next_move = next_player.make_move(board_status)
      record_move(next_move) if legal_move?(next_move)
    end
    
    def next_player
      @next_player = @next_player == @player1 ? @player2 : @player1
    end
    
    def record_move(move)
      @board.record move
    end
  end
end
