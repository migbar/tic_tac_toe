require 'spec_helper'

describe TicTacToe::Player do
  Player = TicTacToe::Player
  Move   = TicTacToe::Player::Move
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
    
    context "when there is knowledge" do
      let(:status) { [[X, nil, nil], [nil, nil, O], [O, nil, nil]] }
      let(:move1) { Move.new(0,1,0) }
      let(:move2) { Move.new(0,2,1) }
      let(:knowledge) { { status => [move1, move2] } }

      before(:each) do
        subject.instance_variable_set("@knowledge", knowledge)
        subject.instance_variable_set("@board_status", status)
      end

      it "returns the move that has the highest score in the knowldege base" do
        subject.next_move(status).should == move2
      end
    end
  end
  
  describe "scoring moves" do
    let(:status) { [[X, nil, nil], [nil, nil, O], [O, nil, nil]] }
    let(:move1) { Move.new(0,1,0) }
    let(:knowledge) { { status => [move1] } }

    before(:each) do
      subject.instance_variable_set("@board_status", status)
      subject.instance_variable_set("@new_move", move1)
    end
    
    it "stores a score of 1 if told that the move was good" do
      subject.good_move
      subject.instance_variable_get("@new_move").score.should == 1
    end
    
    it "stores a score of -1 if told that the move was bad" do
      subject.bad_move
      subject.instance_variable_get("@new_move").score.should == -1
    end
    
  end
end
 