module TicTacToe
  class Game
    attr_reader :player1, :player2, :training

    def self.train!(player1, player2, rounds)
      i = 1
      rounds.times do
        play(player1, player2, true)
        puts "GAME #{i += 1}"
      end
    end

    def self.play(player1, player2, training)
      game = Game.new(player1 ,player2, training)
      game.play
    end
    
    def initialize(player1, player2, training=false)
      @training = training
      @player1, @player2 = player1, player2
      @board = Board.new
    end
    
    def play
      play_round while !over?
      # 2.times do
      #   play_round
      # end
      unless draw?
        winner.good_move
        loser.bad_move
        "\n#{winner.token} wins !! \n#{@board.report}\n********************"
        return  "\n#{winner.token} WINS !!! \n********************".tap do |msg|
          puts(msg) unless self.training
        end
      else
        return "\n DRAW !!! \n********************".tap do |msg|
          puts(msg) unless self.training
        end
      end
    end
    
    def play_round
      up_player = next_player
      move = up_player.next_move(board_status)
      update(move, up_player.token) if legal_move?(move)
    end
    
    def next_player
      @next_player = @next_player == @player1 ? @player2 : @player1
    end
    
    def update(move, token)
      @board.update(move.row, move.col, token)
    end
    
    def board_status
      @board.status
    end
    
    def legal_move?(move)
      @board.empty?(move.row, move.col)
    end
    
    def winner
      return unless winning_line
      players.detect{ |p| winning_line.join("").match(p.token) }
    end
    
    def loser
      return unless winning_line
      players.detect{ |p| p != winner }
    end
    
    def players
      [@player1, @player2]
    end
    
    def over?
      !winning_line.nil? || @board.full?
    end
    
    def draw?
      @board.full? && winning_line.nil?
    end
    
    def winning_line
      @board.lines.detect { |line| complete? line }
    end

  private
    def complete?(line)
      TOKENS.detect {|t| line.count(t) == 3}
    end
    
  end
end
