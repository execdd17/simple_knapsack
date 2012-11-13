require 'genetic_algorithms'

class Knapsack
  CAPACITY, BEST_SCORE = 24, 1000

  def initialize chromosome
    @contents = decode chromosome
  end

  def utilization
    space_used = @contents.inject(0) do |accum, item|
      accum += item.space_needed
    end
    
    (space_used.to_f / CAPACITY * 1000).round
  end

  private

  def decode chromosome
    all_items = Item.create_items({ hammer: 17, coin: 4, pen: 9, wallet: 11 })
    index = -1

    filtered_items = all_items.select do |item|
      index += 1
      chromosome[index] == "1"
    end
  end
end

class Item
  def self.create_items item_hash
    item_hash.inject(Array.new) do |items, (name, space_needed)|
      items << Item.new(name, space_needed)
    end
  end

  def initialize name, space_needed
    @name = name
    @space_needed = space_needed
  end

  attr_reader :name, :space_needed
end

include GeneticAlgorithms

Engine.new(10,4).start(Knapsack::BEST_SCORE) do |chromosome|
  score = Knapsack.new(chromosome).utilization
  score = Knapsack::BEST_SCORE - score if score > Knapsack::BEST_SCORE
  score
end
