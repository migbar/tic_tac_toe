require 'spec_helper'

describe TicTacToe::Memory do
  Memory = TicTacToe::Memory
  Move = TicTacToe::Move
  X = TicTacToe::X
  O = TicTacToe::O
  
  let(:memory){ Memory.new(board_status, X) }
  let(:mongo_col){ mock("mongo_coll") }
  let(:board_status) { "X_X_O_nil_nil_nil_O_O_X" }
  let(:move) { Move.new(0,1,0) }

  describe "when memory for the given board status is not found" do
    
  before(:each) do
    memory.stub(:coll).and_return(mongo_col)
    memory.stub(:update)
    memory.instance_variable_set("@moves", {})
  end
  
  
  it "it should not provide setter method" do
    expect{
      memory.key = "foo"
    }.to raise_error NoMethodError
  end
  
  describe "initialize" do
    it "has the correct state upon creation" do
      memory.board_status.should == board_status
      memory.size.should == 0
    end
  end
  
  describe "#remember" do
    
    it "should remember the move given" do
      lambda{
        memory.remember(move) 
      }.should change(memory.moves, :size).by(1)
    end
    
    it "should call update" do
      memory.should_receive(:update)
      memory.remember(move)
    end
  end
  
  describe "knows_move?" do  
    
    it "answers true if the move has been previously remembered" do
      memory.remember(move)
      memory.knows_move?(move.row, move.col).should == true
    end
    
    it "answers false if the move has never been remembered" do
      puts memory
      memory.knows_move?(move.row, move.col).should == false
    end
  end
  
  describe "#score_for" do
    it "returs the score last remembered for the row and col" do
      memory.remember( Move.new( 1, 2, 0 ) )
      memory.score_for( 1, 2 ).should == 0
    end
    
    it "returns nil if the row col is unknown" do
      memory.score_for(0,0).should == nil
    end
  end
  
  describe "#good_move" do
    let(:move) { Move.new(0,0,0)}
    it "sets the score of the move to 1" do
      memory.remember( move )
      memory.good_move( move )
      memory.score_for( 0, 0 ).should == 1
    end
  end
  
  describe "#bad_move" do
    let(:move) { Move.new(0,0,0)}
    
    it "sets the score of the move to 1" do
      memory.remember( move )
      memory.bad_move( move )
      memory.score_for( 0, 0 ).should == -1
    end
  end
  
  describe "#fetch_good_move" do
    it "returns a move that has a score greater than one" do
      memory.stub(:moves => {"1-2" => 0, "0-2" => 1})
      good_m = memory.fetch_good_move
      good_m.row.should == 0
      good_m.col.should == 2
      good_m.score.should == 1
    end
  end
  
  describe "#fetch_good_move" do
    it "returns a move that has a score less than one" do
      memory.stub(:moves => {"2-0" => -1, "0-1" => 1})
      bad_m = memory.fetch_bad_move
      bad_m.row.should == 2
      bad_m.col.should == 0
      bad_m.score.should == -1
    end
  end
  
  describe "the good the bad and the neutral ..." do
    before(:each) do
      memory.stub(:moves => {"1-1" => 0, "2-0" => 1, "0-1" => -1 })
    end

    describe "#good?" do
      it "returns false for an unknown move" do
        memory.good?(2,2).should be_false
      end
      it "returns true for a move that has a score greater than sero" do
        memory.good?(2,0).should be_true
      end
      it "returns false for a move that has a score less than zero" do
        memory.good?(0,1).should be_false
      end
      it "returns false for a move that has a score equal to zero" do
        memory.good?(1,1).should be_false
      end
    end

    describe "#bad?" do
      it "returns false for an unknown move" do
        memory.bad?(2,2).should be_false
      end
      it "returns true for a move that has a score less than zero" do
        memory.bad?(0,1).should be_true
      end
      it "returns false for a move that has a score greated than zero" do
        memory.bad?(2,0).should be_false
      end
      it "returns false for a move that has a score equal to zero" do
        memory.bad?(1,1).should be_false
      end
    end

    describe "#neutral?" do
      it "returns false for an unknown move" do
        memory.neutral?(2,2).should be_true
      end
      it "returns true for a move that has a score equal to zero" do
        memory.neutral?(1,1).should be_true
      end
      it "returns false for a move that has a score greated than zero" do
        memory.neutral?(2,0).should be_false
      end
      it "returns false for a move that has a score less than zero" do
        memory.neutral?(0,1).should be_false
      end
    end
  end    
  end
  describe "when memory record is found" do
    
  end
end
