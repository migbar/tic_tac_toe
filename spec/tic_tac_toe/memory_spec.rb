require 'spec_helper'

describe TicTacToe::Memory do
  Memory = TicTacToe::Memory
  Move = TicTacToe::Move
  
  subject{ Memory.new(board_status) }
  
  let(:board_status) { "X_X_O_nil_nil_nil_O_O_X" }
  let(:move) { Move.new(0,1,0) }
  
  its(:key) { should == board_status }
  its(:size){ should == 0 }
  
  it "it should not provide setter method" do
    expect{
      subject.key = "foo"
    }.to raise_error NoMethodError
  end
  
  describe "#remember" do
    it "should remember the move given" do
      lambda{
        subject.remember(move) 
      }.should change(subject, :size).by(1)
    end
  end
  
  describe "knows_move?" do  
    it "answers true if the move has been previously remembered" do
      subject.remember(move)
      subject.knows_move?(move.row, move.col).should == true
    end
    
    it "answers false if the move has never been remembered" do
      subject.knows_move?(move.row, move.col).should == false
    end
  end
  
  describe "#score_for" do
    it "returs the score last remembered for the row and col" do
      subject.remember( Move.new( 1, 2, 0 ) )
      subject.score_for( 1, 2 ).should == 0
    end
    
    it "returns nil if the row col is unknown" do
      subject.score_for(0,0).should == nil
    end
  end
  
  describe "#good_move" do
    let(:move) { Move.new(0,0,0)}
    it "sets the score of the move to 1" do
      subject.remember( move )
      subject.good_move( move )
      subject.score_for( 0, 0 ).should == 1
    end
  end
  
  describe "#bad_move" do
    let(:move) { Move.new(0,0,0)}
    
    it "sets the score of the move to 1" do
      subject.remember( move )
      subject.bad_move( move )
      subject.score_for( 0, 0 ).should == -1
    end
  end
  
  describe "#fetch_good_move" do
    it "returns a move that has a score greater than one" do
      subject.stub(:moves => {"1-2" => 0, "0-2" => 1})
      good_m = subject.fetch_good_move
      good_m.row.should == 0
      good_m.col.should == 2
      good_m.score.should == 1
    end
  end
  
  describe "#fetch_good_move" do
    it "returns a move that has a score less than one" do
      subject.stub(:moves => {"2-0" => -1, "0-1" => 1})
      bad_m = subject.fetch_bad_move
      bad_m.row.should == 2
      bad_m.col.should == 0
      bad_m.score.should == -1
    end
  end
  
  describe "the good the bad and the neutral ..." do
    before(:each) do
      subject.stub(:moves => {"1-1" => 0, "2-0" => 1, "0-1" => -1 })
    end

    describe "#good?" do
      it "returns false for an unknown move" do
        subject.good?(2,2).should be_false
      end
      it "returns true for a move that has a score greater than sero" do
        subject.good?(2,0).should be_true
      end
      it "returns false for a move that has a score less than zero" do
        subject.good?(0,1).should be_false
      end
      it "returns false for a move that has a score equal to zero" do
        subject.good?(1,1).should be_false
      end
    end

    describe "#bad?" do
      it "returns false for an unknown move" do
        subject.bad?(2,2).should be_false
      end
      it "returns true for a move that has a score less than zero" do
        subject.bad?(0,1).should be_true
      end
      it "returns false for a move that has a score greated than zero" do
        subject.bad?(2,0).should be_false
      end
      it "returns false for a move that has a score equal to zero" do
        subject.bad?(1,1).should be_false
      end
    end

    describe "#neutral?" do
      it "returns false for an unknown move" do
        subject.neutral?(2,2).should be_true
      end
      it "returns true for a move that has a score equal to zero" do
        subject.neutral?(1,1).should be_true
      end
      it "returns false for a move that has a score greated than zero" do
        subject.neutral?(2,0).should be_false
      end
      it "returns false for a move that has a score less than zero" do
        subject.neutral?(0,1).should be_false
      end
    end
    
  end
end
