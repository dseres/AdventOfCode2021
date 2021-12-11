module AdventOfCode2021::Day11
  extend self
  DAY = 11

  def solution1(input) : Int32
    cavern = CavernOfOctopuses.new(input)
    cavern.step 100
    cavern.flashes
  end

  def solution2(input) : Int32
    cavern = CavernOfOctopuses.new(input)
    count = 0
    while !cavern.is_flashing_all
      count += 1
      cavern.step
    end
    count
  end

  def main
    input = File.read "./src/day#{DAY}/input.txt"
    puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
  end
end
