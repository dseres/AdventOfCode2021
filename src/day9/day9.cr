module AdventOfCode2021
  module Day9
    extend self

    NUMBER = 9

    def parse_input(input : String)
      input.lines.map(&.chars.map(&.to_i8))
    end

    def solution1(input : Array(Array(Int8))) : Int32
      low_points(input).sum do |i, j|
        1 + input[i][j]
      end
    end

    private def low_points(input : Array(Array(Int8))) : Array(Tuple(Int32, Int32))
      low_points = Array(Tuple(Int32, Int32)).new
      (0...input.size).each do |i|
        (0...input[i].size).each do |j|
          if is_low_point(input, i, j)
            low_points << {i, j}
          end
        end
      end
      low_points
    end

    private def is_low_point(input, i, j)
      (i - 1..i + 1).each do |n|
        (j - 1..j + 1).each do |m|
          if in_range(input, n, m) && {n, m} != {i, j} && input[n][m] < input[i][j]
            return false
          end
        end
      end
      true
    end

    private def in_range(input, i, j)
      (0...input.size).includes?(i) && (0...input[i].size).includes?(j)
    end

    def solution2(input) : Int32
      basins = low_points(input).map do |i, j|
        compute_basin(input, [{i, j}], i, j)
      end
      sizes = basins.map(&.size).sort
      sizes.pop * sizes.pop * sizes.pop
    end

    private def compute_basin(input, basin : Array(Tuple(Int32, Int32)), i, j)
      [{i - 1, j}, {i + 1, j}, {i, j - 1}, {i, j + 1}].each
        .select { |n, m| in_range(input, n, m) }
        .select { |n, m| input[i][j] < input[n][m] && input[n][m] < 9 && basin.index({n, m}).nil? }
        .each do |n, m|
          basin << {n, m}
          compute_basin input, basin, n, m
        end
      basin
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
