module TicTacToe
  class Player
    attr_reader :token, :knowledge
    
    def initialize(token)
      @token = token
      @knowledge = Hash.new {|hash, key| hash[key] = []} 
      
    end
    
    def next_move(status)
      @last_status = status
      @last_move = has_knowledge?(status) ? educated_guess(status) : next_sequential(status)
    end
    
    def good_move
      @knowledge[@last_status] << {@last_move => 1}
    end

    def bad_move
      @knowledge[@last_status] << {@last_move => -1}
    end
    
    def educated_guess(status)
      next_m = []
      @knowledge[status].inject(0) do |accum, hash|
        next_m = hash.keys[0] if hash.values[0] > accum
        accum
      end
      next_m
    end
    
    def has_knowledge?(status)
      @knowledge.has_key? status
    end
  private
    def next_sequential(status)
      (0..2).each do |r|
        (0..2).each do |c|
          return [r, c] if status[r][c].nil?
        end
      end
      
    end
    
  end
end