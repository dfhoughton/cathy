# frozen_string_literal: true

require_relative "cathy/version"

##
# Cathy models an updatable weighted probability distribution. It keeps track of the frequency of things
# added to it. Then you can pick one of the things added to it with a probability proportional to the number
# of times it has been added.
class Cathy

  ##
  # Create a new distribution. In its initial state, it will always pick nil.
  def initialize
    @heap = []
    @total = 0
  end

  ##
  # pick an item according to the frequency with which items were added
  def pick
    return if @heap.empty?

    amount = rand 0...@total
    @heap[0].find(amount)
  end

  ##
  # Increment the frequency of this item by one
  def add(item)
    @total += 1
    if (i = index(item))
      child = @heap[i]
      child.increment!
      loop do
        return if child.index.zero?

        # rebalance the heap if necessary
        parent = child.parent
        if parent.count < child.count
          i = child.index
          child.move!(parent.index)
          parent.move!(i)
        else
          parent.clear_parents!
          break
        end
      end
    else
      # new items require minimal work
      i = @heap.length
      child = Item.new(item, @heap, i)
      @heap << child
      child.clear_parents!
    end
  end

  ##
  # Returns a map from the items added to their frequencies.
  def counts
    @heap.to_h { |i| [i.item, i.count] }
  end

  ##
  # Generates a distribution from a map from items to frequencies.
  def self.from_counts(counts)
    heap = []
    counts.each_with_index do |(item, count), i|
      c = Item.new(item, heap, i, count)
      heap << c
      loop do
        break if c.index.zero?

        p = c.parent
        if c.count > p.count
          idx = c.index
          c.move!(p.index)
          p.move!(idx)
        else
          break
        end
      end
    end
    total = counts.values.sum
    new.tap do |obj|
      obj.instance_variable_set :@heap, heap
      obj.instance_variable_set :@total, total
    end
  end

  private

  # because the heap tends to be sorted from most common to least, a linear
  # search is reasonably efficient
  #
  # this returns the index of an item in the heap
  def index(item)
    @heap.index { |c| c.item == item }
  end

  # a container for things added
  #
  # items memoize useful counts
  class Item
    def initialize(item, heap, index, count = 1)
      @heap = heap
      @index = index
      @count = count
      @item = item
    end

    # find an item in this subtree given an "amount"
    def find(amount)
      if amount < left_count
        left.find(amount)
      elsif amount < non_right
        item
      else
        right&.find(amount - non_right) || item
      end
    end

    attr_reader :item, :count, :heap, :index

    def parent
      heap[(index - 1) / 2] if index.positive?
    end

    def left
      (@left ||= [heap[index * 2 + 1]])[0]
    end

    def right
      (@right ||= [heap[index * 2 + 2]])[0]
    end

    def sum
      @sum ||= non_right + right_count
    end

    def left_count
      @left_count ||= left&.sum.to_i
    end

    def right_count
      @right_count ||= right&.sum.to_i
    end

    def non_right
      @non_right ||= left_count + count
    end

    # move in the heap
    def move!(new_index)
      @index = new_index
      heap[new_index] = self
      clear!
    end

    # increment the frequency count
    def increment!
      @count += 1
      clear!
    end

    # clear memoized information
    def clear!
      @left_count = @right_count = @non_right = @sum = @left = @right = nil
    end

    # clear memoization up the ancestor path
    def clear_parents!
      if (p = parent)
        p.clear!
        p.clear_parents!
      end
    end
  end
end
