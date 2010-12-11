module TicTacToe
  class Player
    attr_reader :token, :intelligent

    Move = Struct.new(:row, :col, :score) 
    
    def initialize(token, intelligent=true)
      @intelligent = intelligent
      @token = token
    end

    def next_move(status)
      @board_status = status
      fail_if_suspicious(status)
      return (highest_score_move.clone).tap do |move|
        puts "move is nil - game thrown" if move.nil?
        remember(move) if intelligent
      end
    end

    def good_move
      record_score(1) if intelligent
    end

    def bad_move
      record_score(-1) if intelligent
    end
    
  private
  
    def fail_if_suspicious(status)
      filled_slots = status.flatten.compact.length
      if (filled_slots < 5 && stuck?) #we should not be stuck too early
        raise "player(#{token} throwing GAME! #{board_status} KNOWLEDGE #{known_moves.collect { |e| e.to_s }}"
      end
    end

    def remember(move)
      known_moves.delete_if{ |m| (m.col == move.col) && (m.row == move.row) }
      @new_move = move
      known_moves << new_move
    end
    
    def highest_score_move
      known_moves.detect( method(:next_sequential_move) ) { |move| move.score > 0 }
    end
    
    def random_move
      Move.new(rand(3), rand(3), 0)
    end
    
    def loosing_move
      known_moves.detect { |m| m.score < 0 }
    end
    
    def knows_move?
      knowledge.has_key? board_status
    end
    
    def known_moves
      knowledge[board_status]
    end
    
    def record_score(value)
      new_move.score = value
    end

    def next_sequential_move
      if stuck?
        # dont wanna be stuck again - score the previous move as bad
        record_score -1  
        return loosing_move
      end
      loop do
        rand_m = random_move
        return rand_m if ok?(rand_m)
      end
    end

    def stuck? 
      (0..2).each do |r|
        (0..2).each do |c|
          next_m = Move.new(r, c, 0)    
          return false if ok?(next_m)
        end
      end
      return true
    end

    def ok?(move)
      avail?(move) && ok_move?(move)
    end
    
    def avail?(move)
      board_status[move.row][move.col].nil?
    end
    
    def ok_move?(move)
      known_moves.detect(lambda{nil}) { |m| (m == move) && m.score < 0 }.nil?
    end

    def board_status
      @board_status
    end

    def knowledge
      @knowledge ||= Hash.new {|hash, key| hash[key] = []} 
    end

    def new_move
      @new_move
    end
  end
end