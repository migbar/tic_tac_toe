class TicTacToe::Memory
  
  attr_reader :board_status
  DB_NAME   = "ttt8"
  COLL_NAME = "memory"
  DB_HOST   = "localhost"
  DB_PORT   = 27017
  # WINNING_SCORE = 2
  # DEFENSIVE_SCORE = 1
  
  def self.for_status(status)
    self.new(status)
  end
  
  def initialize(status)
    @board_status = status
    init_mongo_doc
  end
  
  def size
    moves.size
  end
  
  def remember(move)
    remember_score(move, move.score)
  end
  
  # def winning_move(move)
  #   remember_score(move, WINNING_SCORE)
  # end
  # 
  # def defensive_move(move)
  #   remember_score(move, DEFENSIVE_SCORE)
  # end

  # def bad_move(move)
  #   remember_score(move, -1)
  # end
  
  def to_s
    "id:[#{@board_id}] - #{board_status} - moves: #{@moves}"
  end
  
  # def neutral_move(move)
  #   remember_score(move, 0)
  # end
  
  def remember_score(move, score)
    # puts "#{self} about to update. Setting #{move} to #{score}"
    moves["#{move.row}-#{move.col}"] = score
    update
  end
  
  # def knows_move?(row, col)
  #   !score_for(row, col).nil?
  # end
  
  def score_for(row, col)
    moves["#{row}-#{col}"]
  end
  
  def best_move
    found = moves.sort_by { |k,v| v }.reverse.first
    return create_move(found) if found
    # moves.collect do |move, score|
    #   return create_move(move, score) if score > 0
    # end.first
  end
  
  # def fetch_bad_move 
  #   moves.each do |move, score|
  #     return create_move(move, score) if score < 0
  #   end
  # end
  
  # def good?(row, col)
  #   return false unless knows_move?(row, col)
  #   score_for(row, col) > 0
  # end
  # 
  # def bad?(row, col)
  #   return false unless knows_move?(row, col)
  #   score_for(row, col) < 0
  # end
  # 
  # def neutral?(row, col)
  #   !knows_move?(row, col) || score_for(row, col) == 0
  # end

# private  
  def create_move(arr)
    row, col = arr.first.split("-").map(&:to_i)
    TicTacToe::Move.new(row, col, arr.last)
  end
  
  def init_mongo_doc
    if (found = coll.find_one("board_status" => board_status))
      @board_id = found["_id"] 
      @moves = found["moves"]
      # puts "found #{self}"
    else
      @moves = {}
      @board_id = coll.insert(current_board_doc)
      # puts "inserted #{current_board_doc}, i am #{self}"
    end
  end
  
  def update
    res = coll.update({"_id" => @board_id}, {"$set" => {"moves" => moves}} )
    # puts "#{self} AFTER UPDATING"
  end
  
  def moves
    @moves
  end
  
  def coll
    @coll ||= Mongo::Connection.new(DB_HOST, DB_PORT).db(DB_NAME).collection(COLL_NAME)
  end
  
  def current_board_doc
    {"board_status" => board_status, "moves" => moves}
  end
end