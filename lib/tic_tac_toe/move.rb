class TicTacToe::Move
  attr_reader :row, :col, :score

  def initialize(row, col, score)
    @row, @col, @score = row, col, score
  end
end