module TicTacToe
  class Player
    attr_reader :token
    
    def initialize(token)
      @token = token
      @knowledge = Hash.new {|hash, key| hash[key] = []} 
    end
    
    def next_move(status)
      @last_status = status
      @last_move = has_knowledge? ? educated_guess : next_sequential
    end
    
    def good_move
      record_score 1
    end

    def bad_move
      record_score -1
    end
    
    def educated_guess
      next_m = []
      known_moves.inject(0) do |high_score, hash|
        next_m = hash.keys[0] if hash.values[0] > high_score
        high_score
      end
      next_m
    end
    
    def known_moves
      @knowledge[@last_status]
    end
    
    def has_knowledge?
      @knowledge.has_key? @last_status
    end
    
  private
  
    def record_score(value)
      @knowledge[@last_status] << {@last_move => value}
    end
    
    def next_sequential
      (0..2).each do |r|
        (0..2).each do |c|
          return [r, c] if @last_status[r][c].nil?
        end
      end
    end
  end
end