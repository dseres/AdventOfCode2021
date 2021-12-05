module AdventOfCode2021
  module Day5
    extend self

    NUMBER = 5

    def parse_input(input : String) 
      coordinates = Array(Array(Int32)).new
      input.each_line do |line|
        if /^(\d+),(\d+) -> (\d+),(\d+)$/ =~ line
          coordinates << $~[1..4].map &.to_i32
        end
      end
      p! coordinates
      coordinates
    end

    def create_matrix(coordinates)
      max_x = coordinates.max_of { |row| Math.max(row[0], row[2])}
      max_y = coordinates.max_of { |row| Math.max(row[1], row[3])}
      matrix = Array(Array(Int32)).new
      (1..max_x+1).each do
        matrix<<Array(Int32).new(max_y + 1, 0)
      end
      coordinates.each do |vent|
        (vent[0]..vent[2]).each do |x|
          (vent[1]..vent[3]).each do |y|
            matrix[x][y] += 1
          end
        end
      end
      matrix
    end

    def print_matrix(matrix)
      matrix.join("\n"){ |row| row.map{|i| i == 0? "." : i.to_s}.join("")}
    end

    def solution1(input) : Int32
      0
    end

    def solution2(input) : Int32
      0
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
