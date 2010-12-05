require 'spec_helper'

describe TicTacToe::Game do
  Game = TicTacToe::Game
  Player = TicTacToe::Player
  Board = TicTacToe::Board
  X = TicTacToe::X
  O = TicTacToe::O
  
  let(:player1) { Player.new(X) }
  let(:player2) { Player.new(O) }
  let(:board)   { Board.new }
  let(:game)    { Game.new(player1, player2) }
  
  describe ".train!" do
    it "plays the oponents against each other for the specified number of rounds" do
      TicTacToe::Game.should_receive(:play).with(player1, player2).exactly(10).times
      TicTacToe::Game.train!(player1, player2, 10)
    end
  end
  
  describe ".play" do
    # 0. setup new board
    # 1. while none has won
    #   1. ask player 1 for next move (pass in board)
    #     a. if move is legal, update board
    #   2. ask player 2 for next move (pass in board)
    #     a. if move is legal, update board
    
    # let(:game) { mock(Game, :play => nil) }
    
    before(:each) do
      Game.stub(:new => game)
      game.stub(:play => nil)
    end
    
    it "initializes a new Game" do
      Game.should_receive(:new).with(player1, player2).and_return(game)
      Game.play(player1, player2)
    end
    
    it "starts playing the game" do
      game.should_receive(:play)
      Game.play(player1, player2)
    end
  end
  
  describe "#initialize" do
    let(:board) { mock(Board) }
    
    it "sets up a new board" do
      Board.should_receive(:new).and_return(board)
      game = Game.new(player1, player2)
      game.instance_variable_get("@board").should == board
    end
  end
  
  describe "#play" do
    let(:game) { Game.new(player1, player2) }
     
    before(:each) do
      game.stub(:winner => player1)
      game.stub(:looser => player2)
      game.stub(:over? => true)
    end 
    
    it "plays rounds until someone wins" do
      game.should_receive(:over?).exactly(5).times.ordered.and_return(false)
      game.should_receive(:over?).any_number_of_times.ordered.and_return(true)
      game.should_receive(:play_round).exactly(5).times
      game.play
    end
    
    it "tells the winner that it made a good move" do
      game.winner.should_receive(:good_move)
      game.play
    end
    
    it "tells the looser that it made a bad move" do
      game.looser.should_receive(:bad_move)
      game.play
    end
    
  end
  
  describe "#play_round" do
    let(:game) { Game.new(player1, player2) }
    
    let(:board_status) { mock("Board Status") }
    let(:next_move)    { [1,2] }
    let(:next_player)  { mock(Player, :make_move => next_move, :token => X) }
    let(:legal_move?)  { true }

    before(:each) do
      game.stub(:board_status => board_status, :next_player => next_player, :update => nil)
      game.should_receive(:legal_move?).with(1,2).and_return(legal_move?)
    end
    
    it "asks the next player to make a move" do
      game.next_player.should_receive(:make_move).with(game.board_status).and_return(next_move)
      game.play_round
    end
    
    context "when the move is legal" do
      it "updates the board" do
        game.should_receive(:update).with(1, 2, X)
        game.play_round
      end
    end
    
    context "when the move is not legal" do
      let(:legal_move?) { false }
      it "does not update with the move" do
        game.should_not_receive(:update)
        game.play_round
      end
    end
    
  end
  
  describe "#next_player" do
    let(:game) { Game.new(player1, player2) }
    
    it "returns player1 the first time" do
      game.next_player.should == player1
    end
    
    it "it returns player2 the second time" do
      game.next_player
      game.next_player.should == player2
    end
    
    it "it returns player1 the third time" do
      2.times { game.next_player }
      game.next_player.should == player1
    end
  end
  
  describe "#update" do
    let(:game)         { Game.new(player1, player2) }
    let(:next_player)  { mock(Player, :make_move => next_move, :token => X) }
    let(:next_move)    { [1, 2] }
    let(:board_status) { mock("Board Status") }
    
    before(:each) do
      game.stub(:board_status => board_status, :next_player => next_player)
      game.should_receive(:legal_move?).with(1,2).and_return(true)
    end
    
    it "stores the move on the board" do
      game.instance_variable_get("@board").should_receive(:update).with(1, 2, X)
      game.play_round
    end
  end
  
  describe "#board_status" do
    let(:board_status) { mock("Board Status") }
    
    it "gets the status from the board" do
      game.instance_variable_get("@board").should_receive(:status).and_return(board_status)
      game.board_status.should == board_status
    end
  end
  
  describe "#legal_move?" do    
    it "asks the board if the target cell is empty" do
      game.instance_variable_get("@board").should_receive(:empty?).with(2, 1).and_return(true)
      game.legal_move?(2,1)
    end
  end
  
  describe "#over?" do
    let(:rows)  { [[X, nil, nil], [nil, nil, nil], [nil, nil, nil]]}
    let(:cols)  { [[X, nil, nil], [nil, nil, nil], [nil, nil, nil]]}
    let(:diags) { [[X, nil, nil], [nil, nil, nil]] }
    let(:lines) { rows + cols + diags }
    
    before(:each) do
      player1.should_receive(:token).any_number_of_times.and_return(O)
      player2.should_receive(:token).any_number_of_times.and_return(X)
      game.instance_variable_get("@board").stub(:lines => lines)
    end
    
    context "when only one move has been made" do
      it "returns false" do
        game.over?.should be_false
      end      
    end  
      
    context "when there are 3 consecutive cells in the first row with the same token" do
      let(:rows){ [[X, X, X], [nil, nil, nil], [nil, nil, nil]]}
      it "returns true" do
        game.over?.should be_true
      end
    end
    
    context "when there are 3 consecutive cells in the second row with the same token" do
      let(:rows){ [[nil, nil, nil], [X, X, X], [nil, nil, nil]]}
      it "returns true" do
        game.over?.should be_true
      end
    end
    
    context "when there are 3 consecutive cells in the third row with the same token" do
      let(:rows){ [[nil, nil, nil], [nil, nil, nil], [X, X, X]]}
      it "returns true" do
        game.over?.should be_true
      end
    end

    context "when there are 3 consecutive cells in the first col with the same token" do
      let(:cols){ [[X, X, X], [nil, nil, nil], [nil, nil, nil]]}
      it "returns true" do
        game.over?.should be_true
      end
    end
    
    context "when there are 3 consecutive cells in the second col with the same token" do
      let(:cols){ [[nil, nil, nil], [X, X, X], [nil, nil, nil]]}
      it "returns true" do
        game.over?.should be_true
      end
    end
    
    context "when there are 3 consecutive cells in the third col with the same token" do
      let(:cols){ [[nil, nil, nil], [nil, nil, nil], [X, X, X]]}
      it "returns true" do
        game.over?.should be_true
      end
    end
    
    context "when there are 3 consecutive cells in the first diagonal with the same token" do
      let(:diags) {[[X, X, X], [nil, nil, nil]]}
      it "returns true" do
        game.over?.should be_true 
      end
    end
    
    context "when there are 3 consecutive cells in the second diagonal with the same token" do
      let(:diags) {[[nil, nil, nil], [O, O, O]]}
      it "returns true" do
        game.over?.should be_true 
      end
    end
    
  end

  describe "winners and losers" do
    let(:lines) { [] }
    
    before(:each) do
      game.instance_variable_get("@board").stub(:lines => lines)
    end
    
    it "returns nil values if game is not over" do
      game.should_receive(:winning_line).any_number_of_times.and_return(nil)
      game.winner.should be_nil
      game.loser.should be_nil
    end
    
    it "returns non-nil values if game is over" do
      player2.should_receive(:token).any_number_of_times.and_return(O)
      player1.should_receive(:token).any_number_of_times.and_return(X)
      game.should_receive(:winning_line).any_number_of_times.and_return([X, X, X])
      game.winner.should_not be_nil
      game.loser.should_not be_nil
    end
    
    
    context "when 3 'X' tokens in a row" do
      before(:each) do
        game.should_receive(:winning_line).any_number_of_times.and_return([X, X, X])
      end
      
      it "winner is player1 if player1 was playing 'X', loser is player2" do
        player1.should_receive(:token).any_number_of_times.and_return(X)
        player2.should_receive(:token).any_number_of_times.and_return(O)
        game.winner.should == player1
        game.loser.should == player2
      end
      
      it "winner is player2 if player2 was playing 'X', loser is player1" do
        player1.should_receive(:token).any_number_of_times.and_return(O)
        player2.should_receive(:token).any_number_of_times.and_return(X)
        game.winner.should == player2
        game.loser.should == player1
      end
      
    end
    
    context "when 3 'O' tokens in a row" do
      before(:each) do
        game.should_receive(:winning_line).any_number_of_times.and_return([O, O, O])
      end
      
      it "winner is player1 if player1 was playing 'O', loser is player2" do
        player1.should_receive(:token).any_number_of_times.and_return(O)
        player2.should_receive(:token).any_number_of_times.and_return(X)
        game.winner.should == player1
        game.loser.should == player2
      end
      
      it "winner player2 if player2 was playing 'O', loser is player1" do
        player1.should_receive(:token).any_number_of_times.and_return(X)
        player2.should_receive(:token).any_number_of_times.and_return(O)
        game.loser.should == player1
        game.winner.should == player2
      end
    end
  end
end







