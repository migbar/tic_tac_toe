class TicTacToe::Memory
  
  attr_reader :key
  
  def initialize(status)
    @key = status
    @moves = {}
  end
  
  def size
    moves.size
  end
  
  def remember(move)
    remember_score(move, move.score)
  end
  
  def good_move(move)
    remember_score(move, 1)
  end

  def bad_move(move)
    remember_score(move, -1)
  end
  
  def remember_score(move, score)
    moves["#{move.row}-#{move.col}"] = score
  end
  
  def knows_move?(row, col)
    !score_for(row, col).nil?
  end
  
  def score_for(row, col)
    moves["#{row}-#{col}"]
  end
  
  def fetch_good_move 
    moves.collect do |move, score|
      return create_move(move, score) if score > 0
    end.first
  end
  
  def fetch_bad_move 
    moves.each do |move, score|
      return create_move(move, score) if score < 0
    end
  end
  
  def good?(row, col)
    return false unless knows_move?(row, col)
    score_for(row, col) > 0
  end
  
  def bad?(row, col)
    return false unless knows_move?(row, col)
    score_for(row, col) < 0
  end
  
  def neutral?(row, col)
    !knows_move?(row, col) || score_for(row, col) == 0
  end

private  
  def create_move(move_string, score)
    row, col = move_string.split("-").map(&:to_i)
    TicTacToe::Move.new(row, col, score)
  end
  

  
  def moves
    @moves
  end
end