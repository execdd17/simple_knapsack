require 'genetic_algorithms'

class Knapsack
  CAPACITY, BEST_SCORE = 24, 1000
  ALL_ITEMS = { hammer: 17, coin: 4, pen: 9, wallet: 11 }

  def initialize chromosome
    @sizes = decode chromosome
  end

  def utilization
    space_used = @sizes.inject(0) do |space_used, space_needed|
      space_used += space_needed
    end
    
    (space_used.to_f / CAPACITY * 1000).round
  end

  private

  def decode chromosome
    index = 0

    chromosome.each_char.inject(Array.new) do |sizes, c|
      sizes << ALL_ITEMS.values[index] if c == Chromosome::ON
      index += 1
      sizes
    end
  end
end

if __FILE__ == $0
  include GeneticAlgorithms

  Engine.configure do |config|
    config.population_size = 26
    config.num_generations = 1
    config.chromosome_length = Knapsack::ALL_ITEMS.size
  end

  Engine.new.start(Knapsack::BEST_SCORE) do |chromosome|
    score = Knapsack.new(chromosome).utilization
    score = Knapsack::BEST_SCORE - score if score > Knapsack::BEST_SCORE
    score
  end
end