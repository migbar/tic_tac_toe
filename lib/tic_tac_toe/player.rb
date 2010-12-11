module TicTacToe
  class Player
    attr_reader :token, :intelligent

    def initialize(token, intelligent=true)
      @knowledge = {}
      @intelligent = intelligent
      @token = token
    end

    def next_move(status)
      @board_status = status
      # fail_if_suspicious(status)
      return (highest_score_move.clone).tap do |move|
        puts "move is nil - game thrown" if move.nil?
        puts "move is #{move}" 
        
        remember(move) if intelligent
      end
    end

    def good_move
      memory.good_move(current_move) if intelligent
    end

    def bad_move
      memory.bad_move(current_move) if intelligent
    end
    
  private

    def remember(move)
      puts "setting current move to #{move}"
      @current_move = move
      memory.remember(move)
    end
    
    def highest_score_move
      memory.fetch_good_move || next_sequential_move
    end
    
    def random_move
      TicTacToe::Move.new(rand(3), rand(3), 0)
    end
    
    def loosing_move
      memory.fetch_bad_move
    end
        
    def memory
      @knowledge[board_status] ||= Memory.new(board_status)
    end

    def next_sequential_move
      if stuck?
        # dont wanna be stuck again 
        # - score the previous move as bad
        # - and throw in the towel
        memory.remember_score(@current_move, -1)
        # @current_move.score = -1  
        return loosing_move
      end
      loop do
        rand_m = random_move
        return rand_m if ok?(rand_m.row, rand_m.col)
      end
    end

    def stuck? 
      (0..2).each do |r|
        (0..2).each do |c| 
          return false if ok?(r,c)
        end
      end
      return true
    end

    def ok?(r,c)
      avail?(r,c) && ok_move?(r,c)
    end
    
    def avail?(r,c)
      board_status[r][c].nil?
    end
    
    def ok_move?(r,c)
      memory.good?(r,c) || memory.neutral?(r,c)
      # known_moves.detect(lambda{nil}) { |m| (m == move) && m.score < 0 }.nil?
    end

    def board_status
      @board_status
    end

    # def knowledge
    #   @knowledge ||= Hash.new {|hash, key| hash[key] = []} 
    # end

    def current_move
      @current_move
    end
    
    def fail_if_suspicious(status)
      filled_slots = status.flatten.compact.length
      if (filled_slots < 5 && stuck?) #we should not be stuck too early
        raise "player(#{token} throwing GAME! #{board_status} KNOWLEDGE #{known_moves.collect { |e| e.to_s }}"
      end
    end
  end
end