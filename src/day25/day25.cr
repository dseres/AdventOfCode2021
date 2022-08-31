module AdventOfCode2021
  module Day25
    extend self

    DAY = 25

    class SeaCucumbers
      EMPTY = '.'.bytes.first
      LEFT  = '>'.bytes.first
      SOUTH = 'v'.bytes.first

      getter floor = Array(Array(UInt8)).new
      getter steps = 0

      def initialize(input : String)
        @floor = input.lines.map &.bytes
      end

      def to_s(io)
        @floor.each_with_index do |line, i|
          io.write Slice.new(line.to_unsafe, line.size)
          io << "\n" if i < @floor.size - 1
        end
      end

      def_clone
      def_equals @floor

      def step
        step_left
        step_south
        @steps += 1
      end

      private def step_left
        next_floor = @floor.clone
        @floor.each_with_index do |line, j|
          line.each_with_index do |c, i|
            if c == LEFT
              next_i = (i + 1) % line.size
              if line[next_i] == EMPTY
                next_floor[j][next_i] = LEFT
                next_floor[j][i] = EMPTY
              end
            end
          end
        end
        @floor = next_floor
      end

      private def step_south
        next_floor = @floor.clone
        @floor.each_with_index do |line, j|
          line.each_with_index do |c, i|
            if c == SOUTH
              next_j = (j + 1) % @floor.size
              if @floor[next_j][i] == EMPTY
                next_floor[next_j][i] = SOUTH
                next_floor[j][i] = EMPTY
              end
            end
          end
        end
        @floor = next_floor
      end

      def solution1 : Int32
        prev_floor = [] of Array(UInt8)
        while prev_floor != @floor
          prev_floor = @floor
          step
        end
        @steps
      end

      def solution2 : Int32
        0
      end
    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      cucumbers = SeaCucumbers.new input
      puts "Solutions of day#{DAY} : #{cucumbers.solution1}"
    end
  end
end
