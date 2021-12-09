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
      (Math.max(0, i - 1)..Math.min(i + 1, input.size - 1)).each do |n|
        (Math.max(0, j - 1)..Math.min(j + 1, input[n].size - 1)).each do |m|
          if (n != i || m != j) && input[n][m] < input[i][j]
            return false
          end
        end
      end
      true
    end

    def solution2(input) : Int32
      basins = low_points(input).map do |i, j|
        compute_basin(input, [{i, j}], i, j)
      end
      basins = basins.sort &.size
      sizes = basins.map(&.size).sort
      sizes.pop * sizes.pop * sizes.pop
    end

    private def compute_basin(input, basin : Array(Tuple(Int32,Int32)), i, j)
      [{i-1,j},{i+1,j},{i,j-1},{i,j+1}].each do |n,m|
        if (0...input.size).includes?(n) && (0...input[n].size).includes?(m)
          # puts "i : #{i}, j : #{j}, input[i][j] : #{input[i][j]}, n : #{n}, m : #{m}, input[n][m] : #{input[n][m]}"
          if input[i][j] < input[n][m] && input[n][m] < 9 && basin.index({n, m}).nil?
            basin << {n, m}
            compute_basin input, basin, n, m
          end
        end
      end
      basin
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
