module AdventOfCode2021
  module Day23
    extend self

    DAY = 23

    enum RoomType
      Wall
      Hallway
      Hallway_No_Stop
      Room_A
      Room_B
      Room_C
      Room_D
    end

    enum AmphipodaType
      Amber
      Bronze
      Copper
      Desert
    end

    struct Amphipoda
      getter type : AmphipodaType
      getter used_energy = 0
      getter position : Tuple(Int32, Int32)

      def initialize(@type, @position); end

      @@energies : StaticArray(Int32,4) = StaticArray[1, 10, 100, 1000]
      def energy : Int32
        @@energies[@type.to_i]
      end

      def room_to_occupy : RoomType
        RoomType.new(@type.to_i + RoomType::Room_A.to_i)
      end

    end

    struct Room
      getter type : RoomType
      getter position : Tuple(Int32, Int32)
      getter amphipoda : Amphipoda | Nil

      def initialize( @type, @position, @amphipoda = nil); end

      def has_amphipoda : Bool
        !amphipoda.nil?
      end

    end

    class Burrow
      getter rooms : Array(Array(Room))
      getter amphipodas : Array(Amphipoda)

      def initialize(@rooms, @amphipodas); end

      def solved? : Bool
        false
      end
      
      def to_s(io : IO)
      end
    end

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def solution1(input) : Int32
      0
    end

    def solution2(input) : Int32
      0
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
