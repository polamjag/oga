require 'spec_helper'

describe Oga::XML::Node do
  describe '#initialize' do
    it 'sets the node set' do
      set  = Oga::XML::NodeSet.new
      node = described_class.new(:node_set => set)

      node.node_set.should == set
    end
  end

  describe '#children' do
    it 'returns an empty set by default' do
      described_class.new.children.empty?.should == true
    end

    it 'returns a set that was created manually' do
      set  = Oga::XML::NodeSet.new([described_class.new])
      node = described_class.new(:children => set)

      node.children.should == set
    end
  end

  describe '#children=' do
    it 'sets the child nodes using an Array' do
      child = described_class.new
      node  = described_class.new

      node.children = [child]

      node.children[0].should == child
    end

    it 'sets the child nodes using a NodeSet' do
      child = described_class.new
      node  = described_class.new

      node.children = Oga::XML::NodeSet.new([child])

      node.children[0].should == child
    end
  end

  describe '#parent' do
    it 'returns the parent of the node' do
      owner = described_class.new
      set   = Oga::XML::NodeSet.new([], owner)
      node  = described_class.new(:node_set => set)

      node.parent.should == owner
    end

    it 'returns nil if there is no parent node' do
      described_class.new.parent.nil?.should == true
    end
  end

  describe '#previous' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2], owner)
    end

    it 'returns the previous node' do
      @n2.previous.should == @n1
    end

    it 'returns nil if there is no previous node' do
      @n1.previous.nil?.should == true
    end
  end

  describe '#next' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2], owner)
    end

    it 'returns the next node' do
      @n1.next.should == @n2
    end

    it 'returns nil if there is no previous node' do
      @n2.next.nil?.should == true
    end
  end

  describe '#previous_element' do
    before do
      owner = described_class.new
      @n1   = Oga::XML::Element.new
      @n2   = Oga::XML::Text.new
      @n3   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2, @n3], owner)
    end

    it 'returns the previous element of a generic node' do
      @n3.previous_element.should == @n1
    end

    it 'returns the previous element of a text node' do
      @n2.previous_element.should == @n1
    end

    it 'returns nil if there is no previous element' do
      @n1.previous_element.nil?.should == true
    end
  end

  describe '#next_element' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = Oga::XML::Text.new
      @n3   = Oga::XML::Element.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2, @n3], owner)
    end

    it 'returns the next element of a generic node' do
      @n1.next_element.should == @n3
    end

    it 'returns the next element of a text node' do
      @n2.next_element.should == @n3
    end

    it 'returns nil if there is no next element' do
      @n3.next_element.nil?.should == true
    end
  end

  describe '#root_node' do
    before do
      @n4  = described_class.new
      @n3  = described_class.new(:children => [@n4])
      @n2  = described_class.new
      @n1  = described_class.new(:children => [@n2])
      @doc = Oga::XML::Document.new(:children => [@n1])
    end

    it 'returns the root document of an element' do
      @n2.root_node.should == @doc
    end

    it 'returns the root element of another element' do
      @n4.root_node.should == @n3
    end
  end

  describe '#remove' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1], owner)
    end

    it 'returns a node from the node set' do
      @n1.remove

      @set.empty?.should == true
    end

    it 'removes the reference to the set' do
      @n1.remove

      @n1.node_set.nil?.should == true
    end
  end

  describe '#before' do
    before do
      @node      = described_class.new
      @container = described_class.new(:children => [@node])
    end

    it 'inserts a node before another node' do
      other = described_class.new

      @node.before(other)

      @container.children[0].should == other
      @container.children[1].should == @node
    end
  end

  describe '#after' do
    before do
      @node      = described_class.new
      @container = described_class.new(:children => [@node])
    end

    it 'inserts a node after another node' do
      other = described_class.new

      @node.after(other)

      @container.children[0].should == @node
      @container.children[1].should == other
    end
  end
end
