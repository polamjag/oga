require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'descendant-or-self axis' do
    before do
      document = parse('<a><b><b><c class="x"></c></b></b></a>')

      @first_a   = document.children[0]
      @first_b   = @first_a.children[0]
      @second_b  = @first_b.children[0]
      @first_c   = @second_b.children[0]
      @evaluator = described_class.new(document)
    end

    context 'direct descendants' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::b')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <b> node' do
        @set[0].should == @first_b
      end

      example 'return the second <b> node' do
        @set[1].should == @second_b
      end
    end

    context 'nested descendants' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::c')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <c> node' do
        @set[0].should == @first_c
      end
    end

    context 'chained descendants' do
      before do
        @set = @evaluator.evaluate(
          'descendant-or-self::a/descendant-or-self::*'
        )
      end

      it_behaves_like :node_set, :length => 4

      example 'return the <a> node' do
        @set[0].should == @first_a
      end

      example 'return the first <b> node' do
        @set[1].should == @first_b
      end

      example 'return the second <b> node' do
        @set[2].should == @second_b
      end

      example 'return the <c> node' do
        @set[3].should == @first_c
      end
    end

    context 'nested descendants with a matching predicate' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::c[@class="x"]')
      end

      it_behaves_like :node_set, :length => 1
    end

    context 'descendants of a specific node' do
      before do
        @set = @evaluator.evaluate('a/descendant-or-self::b')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <b> node' do
        @set[0].should == @first_b
      end

      example 'return the second <b> node' do
        @set[1].should == @second_b
      end
    end

    context 'descendants matching self' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::a')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <a> node' do
        @set[0].should == @first_a
      end
    end

    context 'descendants of a specific node matching self' do
      before do
        @set = @evaluator.evaluate('a/b/b/c/descendant-or-self::c')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <c> node' do
        @set[0].should == @first_c
      end
    end

    context 'non existing descendants' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::foobar')
      end

      it_behaves_like :empty_node_set
    end

    context 'direct descendants without a matching predicate' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::a[@class]')
      end

      it_behaves_like :empty_node_set
    end

    context 'nested descendants without a matching predicate' do
      before do
        @set = @evaluator.evaluate('descendant-or-self::b[@class]')
      end

      it_behaves_like :empty_node_set
    end

    context 'direct descendants using the short form' do
      before do
        @set = @evaluator.evaluate('//b')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <b> node' do
        @set[0].should == @first_b
      end

      example 'return the second <b> node' do
        @set[1].should == @second_b
      end
    end

    context 'nested descendants using the short form' do
      before do
        @set = @evaluator.evaluate('//c')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <c> node' do
        @set[0].should == @first_c
      end
    end

    context 'descendants of descendants usign the short form' do
      before do
        @set = @evaluator.evaluate('//a//*')
      end

      it_behaves_like :node_set, :length => 3

      example 'return the first <b> node' do
        @set[0].should == @first_b
      end

      example 'return the second <b> node' do
        @set[1].should == @second_b
      end

      example 'return the <c> node' do
        @set[2].should == @first_c
      end
    end

    context 'children of descendants using the short form' do
      before do
        @set = @evaluator.evaluate('//a/b')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <b> node' do
        @set[0].should == @first_b
      end
    end
  end
end
