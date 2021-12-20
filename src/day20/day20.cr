module AdventOfCode2021
  module Day20
    extend self

    DAY = 20

    def parse_input(input : String) : Tuple(Array(Int32), Array(Array(Int32)))
      lines = input.lines
      enchancer = lines[0].chars.map { |c| c == '#' ? 1 : 0 }
      picture = input.lines[2..].map do |line|
        line.chars.map { |c| c == '#' ? 1 : 0 }
      end
      {enchancer, picture}
    end

    def print_pic(pic)
      pic.each do |row|
        puts row.map { |b| b == 1 ? "#" : "." }.join
      end
    end

    def solution1(enchancer : Array(Int32), pic : Array(Array(Int32))) : Int32
      repeat_enchance(enchancer, pic, 2)
    end

    def solution2(enchancer : Array(Int32), pic : Array(Array(Int32))) : Int32
      repeat_enchance(enchancer, pic, 50)
    end

    def repeat_enchance(enchancer, pic, count)
      raise Exception.new("Solution of day 20 will be infinite.") if enchancer.first == 1 && enchancer.last != 0
      must_step = enchancer.first == 1 && enchancer.last == 0
      0.upto(count - 1) do |step|
        pic = enchance(enchancer, pic, must_step ? step % 2 : 0)
      end
      # print_pic pic
      pic.sum &.sum
    end

    private def enchance(enchancer, pic, step)
      new_pic = Array(Array(Int32)).new(pic.size + 2) { Array(Int32).new(pic.size + 2, 0) }
      new_pic.map_with_index do |row, x|
        row.map_with_index do |_, y|
          nine_bit = nearby_nine(pic, x - 1, y - 1, step)
          index = to_int nine_bit
          enchancer[index]
        end
      end
    end

    private def nearby_nine(pic, x, y, step)
      [-1, 0, 1].cartesian_product([-1, 0, 1]).map do |i, j|
        nx = x + i
        ny = y + j
        if (0...pic.size).includes?(nx) && (0...pic[nx].size).includes?(ny)
          pic[nx][ny]
        else
          step
        end
      end
    end

    private def to_int(nine_bit)
      no = 0
      nine_bit.each do |b|
        no = (no << 1) | b
      end
      no
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 *input} #{solution2 *input}"
    end
  end
end
