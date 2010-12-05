require 'spec_helper'

describe TicTacToe::Player do
  Player = TicTacToe::Player
  X = TicTacToe::X
  O = TicTacToe::O
  
  subject{ Player.new(X) }
  
  describe "intialize" do
    it "creates a player with a token" do
      subject.token.should == X
    end
  end
  
  describe "next_move" do
    let(:empty_board){ [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]] }
    let(:busy_board){ [[X, O, X], [X, X, O], [O, nil, X]] }
    let(:full_board){ [[X, O, X], [X, X, O], [O, X, O]] }

    context "when there is no knowledge" do
      it "claims the first cell if the board is empty" do
        move = subject.next_move(empty_board)
        move[0].should == 0
        move[1].should == 0
        # [0,1].include?(move[1]).should be_true
      end

      it "claims the next ascending cell that is open" do
        move = subject.next_move(busy_board)
        move[0].should == 2
        move[1].should == 1
      end      
    end
    
    context "when there is knowledge" do
      let(:status) { [[X, nil, nil], [nil, nil, O], [O, nil, nil]] }
      let(:move1) { [0,1] }
      let(:move2) { [0,2] }
      let(:knowledge) { { status => [ {move1 => 0}, {move2 => 1} ] } }

      before(:each) do
        subject.instance_variable_set("@knowledge", knowledge)
      end

      it "returns the move that has the highest score in the knowldege base" do
        subject.has_knowledge?(status).should == true
        subject.next_move(status).should == move2
      end
    end
  end
  
  describe "scoring moves" do
    let(:status) { [[X, nil, nil], [nil, nil, O], [O, nil, nil]] }
    let(:move1) { [0,1] }
    let(:knowledge) { { status => [ {move1 => 0} ] } }

    before(:each) do
      subject.instance_variable_set("@last_status", status)
      subject.instance_variable_set("@last_move", move1)
    end
    
    it "stores a score of 1 if told that the move was good" do
      subject.good_move
      subject.knowledge.should == { status => [ {move1 => 1} ] }
    end
    
    it "stores a score of -1 if told that the move was bad" do
      subject.bad_move
      subject.knowledge.should == { status => [ {move1 => -1} ] }
    end
    
  end
end
 