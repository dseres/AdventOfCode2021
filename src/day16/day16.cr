require "bit_array"

module AdventOfCode2021
  module Day16
    extend self
    DAY = 16

    enum PacketType
      Sum # =0
      Product
      Minimum
      Maximum
      Literal # = 4
      GreaterThan
      LessThan
      EqualTo
    end

    enum LengthType
      None
      Total
      Count
    end

    class Packet
      getter version = 0
      getter type = PacketType::Literal
      getter length_type = LengthType::None
      getter literal = 0_i64
      getter packet_count = 0
      getter packet_total = 0
      getter subpackets : Array(Packet)?
      getter bits : BitArray
      getter last_bit = 0

      def initialize(hex_str : String)
        @bits = to_bitarray hex_str
        parse_packet
      end

      def initialize(@bits : BitArray)
        parse_packet
      end

      private def to_bitarray(hex_str)
        bits = BitArray.new(hex_str.size * 4)
        (0...hex_str.size).each do |i|
          (0...4).each do |j|
            hex = hex_str[i, 1].to_i(base: 16)
            bits[i * 4 + j] = (hex.bit(3 - j) == 1)
          end
        end
        bits
      end

      private def parse_packet
        parse_version_and_type
        parse_remaining
      end

      private def parse_version_and_type
        @version = bits_to_i bits[0, 3]
        type_bits = bits_to_i bits[3, 3]
        @type = PacketType.from_value(type_bits)
      end

      private def parse_remaining
        case @type
        when PacketType::Literal
          parse_literals
        else
          parse_length_type
          parse_subpackets
        end
      end

      private def bits_to_i(bits)
        number = 0
        bits.each do |b|
          number <<= 1
          number |= (b ? 1 : 0)
        end
        number
      end

      private def parse_literals
        @literal = 0_i64
        @last_bit = 6
        loop do
          digit = bits_to_i bits[@last_bit + 1, 4]
          @last_bit += 5
          @literal = (@literal << 4) | digit
          bits[@last_bit - 5] || break
        end
      end

      private def parse_length_type
        @length_type = bits[6] ? LengthType::Count : LengthType::Total
      end

      private def parse_subpackets
        @subpackets = [] of Packet
        case @length_type
        when LengthType::Count
          parse_subpackets_by_count
        when LengthType::Total
          parse_subpackets_by_total
        end
      end

      private def parse_subpackets_by_count
        @packet_count = bits_to_i bits[7, 11]
        @last_bit = 7 + 11
        packet_count.times do
          next_bits = bits[@last_bit, bits.size - @last_bit]
          next_subpacket = Packet.new next_bits
          @last_bit += next_subpacket.last_bit
          @subpackets.not_nil! << next_subpacket
        end
      end

      private def parse_subpackets_by_total
        @packet_total = bits_to_i bits[7, 15]
        @last_bit = 7 + 15
        while @last_bit < 7 + 15 + @packet_total
          next_bits = bits[@last_bit, 7 + 15 + @packet_total - @last_bit]
          next_subpacket = Packet.new next_bits
          @last_bit += next_subpacket.last_bit
          @subpackets.not_nil! << next_subpacket
        end
      end

      def sum_version
        version = @version
        if !subpackets.nil?
          version += subpackets.not_nil!.sum &.sum_version
        end
        version
      end

      def value : Int64
        case @type
        when PacketType::Sum
          @subpackets.not_nil!.sum &.value
        when PacketType::Product
          @subpackets.not_nil!.product &.value
        when PacketType::Minimum
          @subpackets.not_nil!.min_of &.value
        when PacketType::Maximum
          @subpackets.not_nil!.max_of &.value
        when PacketType::Literal
          @literal.to_i64
        when PacketType::GreaterThan
          (@subpackets.not_nil![0].value > @subpackets.not_nil![1].value ? 1 : 0).to_i64
        when PacketType::LessThan
          (@subpackets.not_nil![0].value < @subpackets.not_nil![1].value ? 1 : 0).to_i64
        else # PacketType::EqualTo
          (@subpackets.not_nil![0].value == @subpackets.not_nil![1].value ? 1 : 0).to_i64
        end
      end
    end

    def solution1(input : String) : Int32
      packet = Packet.new(input)
      # pp! input, packet
      packet.sum_version
    end

    def solution2(input : String) : Int64
      packet = Packet.new(input)
      # pp! input, packet, packet.value
      packet.value
    end

    def main
      input = File.read("./src/day#{DAY}/input.txt").chomp
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
      # pp! input, Packet.new(input)
    end
  end
end
