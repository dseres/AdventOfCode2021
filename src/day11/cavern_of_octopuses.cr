module AdventOfCode2021::Day11
  class CavernOfOctopuses
    getter octopuses = Array(Array(Int8)).new
    getter steps = 0
    getter flashes = 0

    def initialize(str : String)
      @octopuses = str.lines.map(&.chars.map &.to_i8)
    end

    def step(counter)
      (1..counter).each { step }
    end

    def step
      @steps += 1
      increase_level
      flash
      self
    end

    private def increase_level
      octopuses.each_with_index do |row, i|
        row.each_with_index do |_, j|
          @octopuses[i][j] += 1
        end
      end
    end

    private def flash
      octopuses.each_with_index do |row, i|
        row.each_with_index do |_, j|
          flash i, j
        end
      end
    end

    private def flash(x, y)
      if @octopuses[x][y] > 9
        @octopuses[x][y] = 0
        @flashes += 1
        increase_adjacents x, y
      end
    end

    private def increase_adjacents(x, y)
      (x - 1..x + 1).each do |i|
        (y - 1..y + 1).each do |j|
          increase_adjacent i, j
        end
      end
    end

    private def increase_adjacent(x, y)
      if in_range(x, y) && @octopuses[x][y] > 0
        @octopuses[x][y] += 1
        flash x, y
      end
    end

    private def in_range(x, y)
      (0...octopuses.size).includes?(x) && (0...octopuses[x].size).includes?(y)
    end

    def is_flashing_all
        sum = @octopuses.map(&.sum).sum(0.as(Int32))
        sum == 0
    end

    def ==(other : CavernOfOctopuses)
      octopuses == other.octopuses
    end

    def ==(other)
      false
    end
  end
end
