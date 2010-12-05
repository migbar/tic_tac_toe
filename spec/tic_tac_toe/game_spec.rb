require 'spec_helper'

describe TicTacToe::Game do
  Game = TicTacToe::Game
  Player = TicTacToe::Player
  Board = TicTacToe::Board
  
  let(:player1) { mock Player }
  let(:player2) { mock Player }
  
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
    
    let(:game) { mock(Game, :play => nil) }
    
    before(:each) do
      Game.stub(:new => game)
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
    
    it "plays rounds until someone wins" do
      game.should_receive(:winner).exactly(5).times.ordered.and_return(nil)
      game.should_receive(:winner).ordered.and_return(player1)
      game.should_receive(:play_round).exactly(5).times
      game.play
    end
  end
  describe "#play_round" do
    let(:game) { Game.new(player1, player2) }
    
    let(:board_status) { mock("Board Status") }
    let(:next_move)    { mock("Next Move") }
    let(:next_player)  { mock(Player, :make_move => next_move) }
    let(:legal_move?)  { true }

    before(:each) do
      game.stub(:board_status => board_status, :next_player => next_player, :record_move => nil)
      game.should_receive(:legal_move?).with(next_move).and_return(legal_move?)
    end
    
    it "asks the next player to make a move" do
      game.next_player.should_receive(:make_move).with(game.board_status).and_return(next_move)
      game.play_round
    end
    
    context "when the move is legal" do
      it "records the move on the board" do
        game.should_receive(:record_move).with(next_move)
        game.play_round
      end
    end
    
    context "when the move is not legal" do
      let(:legal_move?) { false }
      it "does not record the move" do
        game.should_not_receive(:record_move)
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
  
  describe "#record_move" do
    let(:game) { Game.new(player1, player2) }
    let(:next_player)  { mock(Player, :make_move => next_move) }
    let(:next_move)    { mock("Next Move") }
    let(:board_status) { mock("Board Status") }
    
    before(:each) do
      game.stub(:board_status => board_status, :next_player => next_player)
      game.should_receive(:legal_move?).with(next_move).and_return(true)
    end
    
    it "stores the move on the board" do
      game.instance_variable_get("@board").should_receive(:record).with(next_move)
      game.play_round
    end
  end
end







