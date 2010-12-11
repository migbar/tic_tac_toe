require 'spec_helper'

describe TicTacToe::Board do
  Board = TicTacToe::Board
  X = TicTacToe::X
  O = TicTacToe::O
    
  describe "#status" do
    
    subject{Board.new}
    let(:rows){ [[X, O, X], [nil, nil, nil], [nil, nil, nil]] }

    before(:each) do
      subject.instance_variable_set("@rows", rows)      
    end

    it "returns a deep copy of the board rows" do
      subject.status.should == rows
    end

    it "cannot be used to alter the board" do
      subject.status[0] = ["foo", "bar", "baz"]
      subject.status[0][1] = "ruby"
      subject.status.should == [[X, O, X], [nil, nil, nil], [nil, nil, nil]]      
    end
  end
  
  describe "#empty?" do
    let(:rows){ [[X, nil, X], [nil, nil, nil], [nil, nil, nil]] }
    
    before(:each) do
      subject.instance_variable_set("@rows", rows)      
    end
    
    it "returns true if a cell is empty" do
      subject.empty?(0,1).should be_true
    end
    
    it "returns false if a cell is not empty" do
      subject.empty?(0,0).should be_false
    end
  end
  
  describe "#full?" do
    
    before(:each) do
      subject.instance_variable_set("@rows", rows)      
    end
    
    context "when there are available cells" do
      let(:rows){ [[X, nil, O], [nil, X, nil], [nil, X, O]] }
      
      it "returns false" do
        subject.full?.should be_false
      end
    end
    
    context "when there are no available cells" do
      let(:rows){ [[X, X, O], [O, X, O], [X, O, X]] }
      
      it "returns true" do
        subject.full?.should be_true
      end
    end
    
  end
  
  describe "#update" do
    let(:rows){ [[X, nil, O], [nil, nil, nil], [nil, nil, nil]] }

    before(:each) do
      subject.instance_variable_set("@rows", rows)      
    end
    
    it "updates the rows with the move" do
      subject.update(1, 2, X)
      subject.status.should == [[X, nil, O], [nil, nil, X], [nil, nil, nil]] 
    end
  end
  
  describe "#lines" do
    let(:rows){ [[X, O, X], [X, X, O], [O, nil, O]] }

    before(:each) do
      subject.instance_variable_set("@rows", rows)      
    end
    
    it "returns an array of line combinations that are used for scoring" do
      subject.lines.should == [[X, O, X], [X, X, O], [O, nil, O], [X, X, O], [O, X, nil], [X, O, O], [X, X, O], [X, X, O]]
    end
    
    it "cannot be used to alter the board" do
      subject.lines[0] = ["foo", "bar", "baz"]
      subject.lines[0][1] = "ruby"
      subject.lines.should == [[X, O, X], [X, X, O], [O, nil, O], [X, X, O], [O, X, nil], [X, O, O], [X, X, O], [X, X, O]]
    end
  end
end
