module AdventOfCode2021
  module Day3
    extend self

    NUMBER = 3

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def solution1(input) : Int32
      gamma = 0
      epsilon = 0
      (0..input[0].size - 1).each do |i|
        count_0, count_1 = count_bits input, i
        if count_1 > count_0
          gamma = (gamma << 1) | 1
          epsilon <<= 1
        else
          gamma <<= 1
          epsilon = (epsilon << 1) | 1
        end
      end
      gamma * epsilon
    end

    private def count_bits(input, i)
      count_0 = 0
      count_1 = 0
      (0..input.size - 1).each do |j|
        if input[j][i] == '0'
          count_0 += 1
        else
          count_1 += 1
        end
      end
      {count_0, count_1}
    end

    def solution2(input) : Int32
      o2 = find_o2 input, 0
      co2 = find_co2 input, 0
      o2.to_i32(base = 2) * co2.to_i32(base = 2)
    end

    private def find_o2(input, bit)
      #p! input

      if input.size == 1
        return input[0]
      end
      input2 = select_o2_numbers input, bit
      return find_o2(input2, (bit + 1) % input[0].size)
    end

    private def find_co2(input, bit)
      #p! input
      if input.size == 1
        return input[0]
      end
      input2 = select_co2_numbers input, bit
      return find_co2(input2, (bit + 1) % input[0].size)
    end

    private def select_o2_numbers(input, bit)
      count_0, count_1 = count_bits input, bit
      #p! count_0, count_1
      if (count_1 >= count_0)
        input.select { |n| n[bit] == '1' }
      else
        input.select { |n| n[bit] == '0' }
      end
    end

    def select_co2_numbers(input, bit)
      count_0, count_1 = count_bits input, bit
      #p! count_0, count_1
      if (count_0 <= count_1)
        input.select { |n| n[bit] == '0' }
      else
        input.select { |n| n[bit] == '1' }
      end
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
