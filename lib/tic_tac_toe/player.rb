module TicTacToe
  class Player
    WINNING_SCORE = 1

    attr_reader :token, :intelligent

    def initialize(token, ai=true)
      @intelligent = ai
      @token = token
    end

    def next_move(status)
      @board_status = status
      # puts "in next move(#{token}) just set board status to #{status_string(board_status)}"
      return best_move
      # return (best_move.clone).tap { |move| @last_move = move }
    end

    def winning_move(row, col)
      puts "in winning move(#{token}) winning move is #{row}, #{col} for board: #{status_string(board_status)}"
      remember(Move.new(row, col, WINNING_SCORE)) if intelligent
    end
    
    def persist_memory
      File.open( "memory_for_player_#{token}.yaml", 'w' ) do |out|
          YAML.dump( memory, out )
        end
    end
    
  private
    def remember(move)
      memory[status_string(board_status)] << move
    end
    
    def best_move
      best = (intelligent && best_move_from_memory) || any_move
      puts "in best move(#{token}), for status:#{status_string(board_status)} - returning #{best}"
      best
    end
    
    def best_move_from_memory
      memory[status_string(board_status)].sort_by { |m| m.score }.first
    end

    def any_move
      loop do
        rand_m = TicTacToe::Move.new(rand(3), rand(3), 0)
        return rand_m if available?(rand_m.row, rand_m.col)
      end
    end

    def available?(r,c)
      board_status[r][c].nil?
    end

    def board_status
      @board_status
    end

    def memory
      @mem ||= Hash.new {|h,k| h[k] = [] }
    end
    
    def intelligent
      @intelligent
    end
    
    def status_string(status)
      status.flatten.collect do |e|
        e.nil? ? "nil" : e
      end.join("_") + "-[#{token}]"
    end 
    # def load_memory
    #   @mem = Memory.for_status(status_string(board_status))
    #   # if last_status
    #   #   puts "Attempt to load last mem for last status #{last_status}"
    #   #   @last_mem = Memory.for_status(status_string(last_status)) 
    #   #   puts "@last_mem loaded: #{@last_mem} "
    #   # end
    # end
    # def last_status
    #   @last_status
    # end
    # def fail_if_suspicious(status)
    #   filled_slots = status.flatten.compact.length
    #   if (filled_slots < 5 && stuck?) #we should not be stuck too early
    #     raise "player(#{token} throwing GAME! #{board_status} KNOWLEDGE #{known_moves.collect { |e| e.to_s }}"
    #   end
    # end
    
    # def give_up
    #   memory.fetch_bad_move
    # end
    # 
    # def next_sequential_move
    #   if stuck?
    #     learn_opponents_last_move if intelligent
    #     return give_up # for now ;)
    #   end
    #   next_open_move
    # end

    # 
    # def opponents_last_move
    #   puts "about to learn opponents last move the board_status now: #{status_string(board_status)}, the last_status then: #{status_string(last_status)}"
    #   # puts "about to learn opponents last move"
    #   
    # end
    
    # def learn_opponents_last_move
    #   # dont wanna be stuck again 
    #   # - the opponents last move is the one we should have made
    #   # opponents_last_move(board_status, last_status)
    #   # puts "STUCK ! - telling last memory #{last_mem} to set the opponents last move #{opponents_last_move} to 1"
    #   # previous_memory.remember_score(opponents_last_move, 1)
    #   puts "STUCK ! - telling last memory #{last_mem} to set last move #{last_move} to -1"
    #   last_mem.remember_score(last_move, -1)
    # end
    # def good_move(last_move)
    #   puts "in good move(#{token}) - mem: #{memory} - last_mem: #{last_memory}"
    #   memory.winning_move(last_move) if intelligent
    # end
    # 
    # def opponents_good_move(opponents_move)
    #   puts "in bad move(#{token}) - mem: #{memory} - last mem: #{last_memory} "
    #   memory.defensive_move(opponents_last_move) if intelligent
    #   # block_opponents_last_move if intelligent
    #   # # memory.good_move(opponents_last_move) if intelligent
    # end
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
    
    def ok_move?(r,c)
      return true unless intelligent
      memory.good?(r,c) || memory.neutral?(r,c)
    end
    # def neutral_move
    #   memory.neutral_move(last_move) if intelligent
    # end
    # def last_memory
    #   @last_mem
    # end
    # 
    # def last_move
    #   @last_move
    # end
  end
end