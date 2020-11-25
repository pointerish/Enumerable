require_relative '../enumerable_blocks'

RSpec.describe 'what this Enumerable module' do
  let(:num_array) { [1, 2, 3] }
  let(:str_array) { %w[the sumerians ruled] }
  let(:my_range) { (1..3) }
  let(:my_hash) { { obj: 'Object', obj1: 'Object1' } }
  let(:my_results) { [] }
  let(:my_proc) { proc { |item| item * 2 } }

  describe '#my_each' do
    it 'does not change the original array' do
      expect(num_array.my_each { |num| num * 2 }).to eq(num_array)
    end

    it 'receives a Range with no errors' do
      expect(my_range.my_each { |num| num * 2 }).to eq(my_range)
    end

    it 'receives a Hash with no errors' do
      expect(my_hash.my_each { |elem| elem }).to eq(my_hash)
    end

    it 'returns an Enumerator when no block is provided' do
      expect(num_array.my_each).to be_an(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'does not change the original array' do
      expect(num_array.my_each_with_index { |index, num| index * num }).to eq(num_array)
    end

    it 'provides interface for both index and item' do
      num_array.my_each_with_index do |index, num|
        my_results << [index, num]
      end
      expect(my_results).to eq([[1, 0], [2, 1], [3, 2]])
    end

    it 'receives a Range with no errors' do
      expect(my_range.my_each_with_index { |index, val| index * val }).to eq(my_range)
    end

    it 'receives a Hash with no errors' do
      expect(my_hash.my_each_with_index { |_index, val| val }).to eq(my_hash)
    end

    it 'returns an Enumerator when no block is provided' do
      expect(num_array.my_each_with_index).to be_an(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns values based on argument' do
      expect(num_array.my_select(&:odd?)).to eq([1, 3])
    end

    it 'returns values based on argument from a range' do
      expect(my_range.my_select(&:odd?)).to eq([1, 3])
    end

    it 'returns values based on block' do
      expect(my_range.my_select { |elem| elem > 1 }).to eq([2, 3])
    end

    it 'returns an Enumerator when no block is provided' do
      expect(num_array.my_select).to be_an(Enumerator)
    end
  end

  describe '#my_all?' do
    it 'returns true if block condition is true for all items in collection' do
      expect(num_array.my_all? { |item| item.instance_of? Integer })
        .to eq(true)
    end

    it 'returns false if at least one collection item does not meet block condition' do
      expect(num_array.my_all? { |item| item.instance_of? String })
        .to eq(false)
    end
  end

  describe '#my_any?' do
    it 'returns true if any of the collection items meets block condition' do
      expect(num_array.my_any? { |item| item > 2 })
        .to eq(true)
    end

    it 'returns false if none of the collection items meets block condition' do
      expect(num_array.my_any? { |item| item > 5 })
        .to eq(false)
    end
  end

  describe '#my_none?' do
    it 'returns true if none of the collection items meets block condition' do
      expect(num_array.my_none? { |item| item > 6 })
        .to eq(true)
    end

    it 'returns false if all of the collection items meets block condition' do
      expect(num_array.my_none? { |item| item < 6 })
        .to eq(false)
    end
  end

  describe '#my_count' do
    it 'returns count of items in the collection that meet the block condition' do
      expect(num_array.my_count { |item| item > 6 })
        .to eq(0)
    end

    it 'returns count of items in the range that meet the block condition' do
      expect(my_range.my_count { |item| item < 3 })
        .to eq(2)
    end

    it 'returns count of items in the hash that meet the block condition' do
      expect(my_hash.my_count)
        .to eq(2)
    end

    it 'returns count of items in the hash that meet the parameters' do
      expect(str_array.my_count('sumerians'))
        .to eq(1)
    end
  end

  describe '#my_map' do
    it 'builds new array' do
      expect(num_array.my_map { |item| item + 1 }).to eq([2, 3, 4])
    end

    it 'receives a range and build new array' do
      expect(my_range.my_map { |item| item + 1 }).to eq([2, 3, 4])
    end

    it 'receives proc as a parameter' do
      expect(num_array.my_map(&my_proc)).to eq([2, 4, 6])
    end

    it 'returns Enumerator when no block is given' do
      expect(num_array.my_map).to be_an(Enumerator)
    end
  end

  describe '#my_inject' do
    it 'returns sum of all collection items' do
      expect(num_array.my_inject(:+)).to eq(6)
    end

    it 'returns sum of all range items with the condition given in the block' do
      expect(my_range.my_inject { |item, n| item + n }).to eq(6)
    end

    it 'receives two arguments and returns the result' do
      expect(num_array.my_inject(1, :*)).to eq(6)
    end

    it 'The methods receives a zero value as a parameter' do
      expect(num_array.my_inject(0, :*)).to eq(0)
    end
  end

  describe '#multiply_els' do
    it 'returns product of all collection items' do
      expect(multiply_els(num_array)).to eq(6)
    end
  end
end
