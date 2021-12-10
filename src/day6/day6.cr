module AdventOfCode2021
  module Day6
    extend self

    DAY = 6

    def parse_input(input : String) : Array(Int64)
      fishes = Array(Int64).new(9, 0)
      input.split(",").map { |s| s.to_i32 }.each { |i| fishes[i] += 1 }
      fishes
    end

    def step_fishes(fishes, round)
      # p! fishes
      (1..round).each do
        fishes_new = Array(Int64).new(9, 0)
        (1..8).each do |i|
          fishes_new[i - 1] = fishes[i]
        end
        fishes_new[6] += fishes[0]
        fishes_new[8] = fishes[0]
        fishes = fishes_new
        # p! fishes
      end
      fishes
    end

    def solution1(fishes) : Int64
      step_fishes(fishes, 80).sum
    end

    def solution2(fishes) : Int64
      step_fishes(fishes, 256).sum
    end

    def main
      fishes = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 fishes} #{solution2 fishes}"
    end
  end
end
