module TicTacToe
  class Game
    attr_reader :player1, :player2, :training, :last_move

    def self.train!(player1, player2, rounds)
      i = 1
      rounds.times do
        play(player1, player2, true)
        puts "GAME #{i += 1}"
      end
      player1.persist_memory
      player2.persist_memory
    end

    def self.play(player1, player2, training=false)
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
      if draw?
        # @player1.neutral_move
        # @player2.neutral_move
        return "\n DRAW !!! \n********************".tap do |msg|
          puts(msg) #unless self.training
        end
      else
        # winner.good_move(last_move)
        # loser.opponents_good_move(last_move)
        puts "winner is - #{winner.token}"
        winner.winning_move(last_move.row, last_move.col)
        puts "loser is - #{loser.token}"
        loser.winning_move(last_move.row, last_move.col)
        
        "\n#{winner.token} wins !! \n#{@board.report}\n********************"
        return  "\n#{winner.token} WINS !!! \n********************".tap do |msg|
          puts(msg) #unless self.training
        end
      end
    end
    
    def play_round
      up_player = next_player
      @last_move = up_player.next_move(board_status)
      update(up_player.token) #if legal_move?(last_move)
    end

    def next_player
      @next_player = @next_player == @player1 ? @player2 : @player1
    end
    
    def update(token)
      @board.update(last_move.row, last_move.col, token)
    end
    
    def board_status
      @board.status
    end
    
    # def legal_move?(move)
    #   @board.empty?(move.row, move.col)
    # end
    
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
