module TicTacToe
  class Board
    
    def initialize
      @rows = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil] ]
    end
    
    def status
      rows.collect {|r| r.clone}
    end
    
    # def status
    #   @rows.flatten.collect do |e|
    #     e.nil? ? "nil" : e
    #   end.join("_")
    # end
    
    def empty?(row, col)
      rows[row][col].nil?
    end
    
    def full?
      @rows.flatten.compact.length == 9
    end
    
    def update(row, col, token)
      rows[row][col] = token
      # puts "\n "
      # puts "player(#{token}) moves: to (#{row},#{col})"
      # puts report
      # puts "\n"
    end
    
    def lines
      lines = []
      rows.each  { |r| lines << r.clone }
      cols.each  { |c| lines << c.clone }
      diags.each { |d| lines << d.clone }
      lines
    end
    
    def report
      res = []
      (0..2).each do |r|
        res << " #{@rows[r][0] || " "} | #{@rows[r][1] || " "} | #{@rows[r][2] || " "} "
      end
      res.join("\n-----------\n")
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