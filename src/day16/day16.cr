require "bit_array"

module AdventOfCode2021
  module Day16
    extend self
    DAY = 16

    class Packet
      getter version =0
      getter type = 0
      getter literal = 0
      getter packets = [] of Packet
    end

    def solution1(input : String) : Int32
      bits = to_bitarray input
      6
    end

    private def to_bitarray(input)
      bits = BitArray.new(input.size * 4)
      (0...input.size).each do |i|
        (0...4).each do |j|
          hex = input[i,1].to_i(base: 16)
          bits[ i * 4 + j] = (hex.bit(3-j) == 1)
        end
      end
      pp! bits
      bits
    end

    def solution2(input : String) : Int32
      0
    end

    def main
      input = File.read("./src/day#{DAY}/input.txt").chomp
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
