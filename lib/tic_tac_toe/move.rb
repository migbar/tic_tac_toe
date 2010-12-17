class TicTacToe::Move
  # include Mongoid::Document
  
  attr_reader :row, :col, :score

  def initialize(row, col, score)
    @row, @col, @score = row, col, score
  end
  
  def to_s
    "(#{row}-#{col})=>#{score}"
  end
end