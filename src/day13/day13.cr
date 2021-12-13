module AdventOfCode2021
  module Day13
    extend self

    DAY = 13

    struct Point
      property x : Int32
      property y : Int32

      def initialize(@x, @y); end
    end

    enum Axis
      X
      Y
    end

    struct Folding
      property axis : Axis
      property line : Int32

      def initialize(@axis, @line); end
    end

    class ElvesCameraManual
      getter points : Set(Point)
      getter foldings : Array(Folding)

      def initialize(input : String)
        part_of_points, part_of_folding = input.split("\n\n")
        @points = parse_points part_of_points
        @foldings = parse_foldings part_of_folding
      end

      private def parse_points(str)
        str.lines.map do |line|
          x, y = line.split(",").map &.to_i32
          Point.new x, y
        end.to_set
      end

      private def parse_foldings(str)
        str.lines.map do |line|
          axis, number = line.split(" ")[2].split("=")
          Folding.new Axis.parse(axis), number.to_i32
        end
      end

      def do_folding
        foldings.each do |folding|
          fold_one folding
        end
        points.size
      end

      def do_folding_one
        fold_one foldings.first
        points.size
      end
      
      def fold_one(folding)
        if folding.axis == Axis::X
          fold_x folding.line
        else
          fold_y folding.line
        end
      end

      private def fold_x(line)
        points.dup.each do |pt|
          if pt.x > line
            points.delete pt
            points.add? Point.new line - (pt.x - line), pt.y
          end
        end
      end

      private def fold_y(line)
        points.dup.each do |pt|
          if pt.y > line
            points.delete pt
            points.add? Point.new pt.x, line - (pt.y - line)
          end
        end
      end

      def to_s
        io = IO::Memory.new
        max_x = points.max_of &.x
        max_y = points.max_of &.y
        (0..max_y).each do |y|
          (0..max_x).each do |x|
            if points.includes? Point.new(x, y)
              io.print "#"
            else
              io.print " "
            end
          end
          io.print "\n"
        end
        io.to_s
      end
    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      paper = ElvesCameraManual.new(input)
      puts "Solutions of day#{DAY} part 1: #{paper.do_folding_one}"
      paper.do_folding
      puts "Solutions of day#{DAY} part 2:"
      puts paper.to_s
    end
  end
end
