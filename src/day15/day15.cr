module AdventOfCode2021
  module Day15
    extend self
    DAY = 15

    class Cave
      getter chitons : Array(Array(Int8))
      @risks = Array(Array(Int32)).new
      @next_set = Set(Tuple(Int32, Int32)).new

      def initialize(input : String)
        @chitons = input.lines.map &.chars.map &.to_i8
      end

      def solution1 : Int32
        # Initialize arrays
        @risks = Array(Array(Int32)).new(@chitons.size) { |i| Array(Int32).new(@chitons[i].size, 0) }
        @risks[0][0] = @chitons[0][0].to_i32
        @next_set = [{1, 0}, {0, 1}].to_set
        while @next_set.size > 0 && @risks[@risks.size - 1][@risks[@risks.size - 1].size - 1] == 0
          process_next
        end
        # @risks.each{|row| 
        #   row.each{|risk| printf("%4d", risk)}
        #   puts ""
        # }
        @risks[@risks.size - 1][@risks[@risks.size - 1].size - 1] - @chitons[0][0]
      end

      private def process_next
        x0, y0 = @next_set.min_by { |x, y| @risks[x][y] }
        @next_set.delete({x0, y0})
        #neighbours = neighbours_of x0, y0
        #pp!({x0, y0}, @next_set, neighbours)
        set_current_risk x0, y0
        compute_next_node x0, y0
        #pp!(@risks)
        #gets
      end

      private def neighbours_of(x, y)
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}].select do |x, y|
          0 <= x && x < @chitons.size && 0 <= y && y < @chitons[x].size
        end
      end

      private def set_current_risk(x0, y0)
        neighbours = neighbours_of x0, y0
        x, y = neighbours.select { |x, y| @risks[x][y] > 0 }.min_by { |x, y| @risks[x][y] }
        @risks[x0][y0] = @risks[x][y] + @chitons[x0][y0]
      end

      private def compute_next_node(x0, y0)
        neighbours = neighbours_of x0, y0
        neighbours.each do |x, y|
          if @risks[x][y] > 0 && @risks[x][y] > @risks[x0][y0] + @chitons[x][y]
            @risks[x][y] = @risks[x0][y0] + @chitons[x][y]
            compute_next_node x,y
          elsif @risks[x][y] == 0
            @next_set << {x, y}
          end
        end
      end
        
      private def compute_neigbours(x0, y0)
        neighbours = neighbours_of x0, y0
        neighbours.each do |x,y|
          if @risks[x][y] > 0 && @risks[x][y] > @risks[x0][y0] + @chitons[x][y]
            @risks[x][y] = @risks[x0][y0] + @chitons[x][y]
            compute_neigbours x,y
          end
        end
      end

      def solution2 : Int32
        0
      end
    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      cave = Cave.new(input)
      puts "Solutions of day#{DAY} : #{cave.solution1} #{cave.solution2}"
    end
  end
end
