require 'spec_helper'

describe TicTacToe::Player do
  Player = TicTacToe::Player
  Move   = TicTacToe::Move
  Memory = TicTacToe::Memory
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
    let(:busy_board){ "X_O_X_X_X_O_O_nil_X" }
    let(:full_board){ "X_O_X_X_X_O_O_X_O" }
    
    context "when there is knowledge" do
      let(:status) { "X_nil_nil_nil_nil_O_O_nil_nil" }
      let(:move1)  { Move.new(0,1,0) }
      let(:move2)  { Move.new(0,2,1) }
      let(:memory) { Memory.new( status, X ) }
      let(:knowledge) { { status => memory } }

      before(:each) do
        subject.stub(:memory => memory)
      end

      it "returns a good move from memory" do
        memory.should_receive(:fetch_good_move).and_return(move2)
        next_m = subject.next_move(status)
        next_m.row.should == move2.row
        next_m.col.should == move2.col
      end
    end
  end
  
  describe "scoring moves" do
    let(:status) { "X_nil_nil_nil_nil_O_O_nil_nil" }
    let(:move1) { Move.new(0,1,0) }
    let(:memory) { Memory.new( status, X ) }

    before(:each) do
      subject.stub(:last_move => move1)
      subject.stub(:memory => memory)
    end
    
    it "tells memory to put a good move score on the current move" do
      memory.should_receive(:good_move).with(move1)
      subject.good_move
    end
    
    it "tells memory to put a bad move score on the current move" do
      memory.should_receive(:bad_move).with(move1)
      subject.bad_move
    end
  end
end
 