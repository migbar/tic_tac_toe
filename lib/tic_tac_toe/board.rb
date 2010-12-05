module TicTacToe
  class Board
    
    def initialize
      @rows = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil] ]
    end
    
    def status
      rows.collect {|r| r.clone}
    end
    
    def empty?(row, col)
      rows[row][col].nil?
    end
    
    def update(row, col, token)
      rows[row][col] = token
    end
    
    def lines
      lines = []
      rows.each  { |r| lines << r.clone }
      cols.each  { |c| lines << c.clone }
      diags.each { |d| lines << d.clone }
      lines
    end
    
  private
    def rows
      @rows
    end
    
    def cols
      @rows.transpose
    end
    
    def diags
      diags = []
      diags << [rows[0][0], rows[1][1], rows[2][2]]
      diags << [rows[0][2], rows[1][1], rows[2][0]]
    end
  end
  
end