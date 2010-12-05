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
      play_round while !over?
      winner.good_move
      looser.bad_move
    end
    
    def play_round
      up_player = next_player
      row, col = up_player.make_move(board_status)
      update(row, col, up_player.token) if legal_move?(row, col)
    end
    
    def next_player
      @next_player = @next_player == @player1 ? @player2 : @player1
    end
    
    def update(row, col, token)
      @board.update(row, col, token)
    end
    
    def board_status
      @board.status
    end
    
    def legal_move?(row, col)
      @board.empty?(row, col)
    end
    
    def winner
      return unless (line = winning_line)
      [@player1, @player2].detect {|p| line.join("").match(p.token) }
    end
    
    def over?
      !winning_line.nil?
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
