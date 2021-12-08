module AdventOfCode2021
  module Day5
    extend self

    NUMBER = 5

    def parse_input(input : String)
      vents = Array(Array(Int32)).new
      input.each_line do |line|
        if /^(\d+),(\d+) -> (\d+),(\d+)$/ =~ line
          vents << $~[1..4].map &.to_i32
        end
      end
      vents
    end

    def create_matrix(vents)
      max_x = vents.max_of { |row| Math.max(row[0], row[2]) }
      max_y = vents.max_of { |row| Math.max(row[1], row[3]) }
      matrix = Array(Array(Int32)).new
      (1..max_y + 1).each do
        matrix << Array(Int32).new(max_x + 1, 0)
      end
      matrix
    end

    def add_horizontal_or_vertiacals(matrix, vents)
      vents.each do |vent|
        x1, y1, x2, y2 = vent
        if x1 == x2 || y1 == y2
          (Math.min(x1, x2)..Math.max(x1, x2)).each do |x|
            (Math.min(y1, y2)..Math.max(y1, y2)).each do |y|
              matrix[y][x] += 1
            end
          end
        end
      end
    end

    def add_diagonals(matrix, vents)
      vents.each do |vent|
        x1, y1, x2, y2 = vent
        if (x2 - x1).abs == (y2 - y1).abs && x1 != x2
          di = x1 < x2 ? 1 : -1
          dj = y1 < y2 ? 1 : -1
          i = x1
          j = y1
          loop do
            matrix[j][i] += 1
            i == x2 && break
            i += di
            j += dj
          end
        end
      end
    end

    def print_matrix(matrix)
      matrix.join("\n") { |row| row.map { |i| i == 0 ? "." : i.to_s }.join("") }
    end

    def solution1(matrix) : Int32
      matrix.sum &.count { |v| v >= 2 }
    end

    def solution2(matrix) : Int32
      solution1 matrix
    end

    def main
      vents = parse_input File.read "./src/day#{NUMBER}/input.txt"
      matrix = create_matrix vents

      add_horizontal_or_vertiacals matrix, vents
      r1 = solution1 matrix

      add_diagonals matrix, vents
      r2 = solution2 matrix
      puts "Solutions of day : #{r1} #{r2}"
    end
  end
end
