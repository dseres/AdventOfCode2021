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
      getter rooms = [] of Array(RoomType);
      getter amphipodas = [] of Amphipoda;

      def initialize(@rooms, @amphipodas); end

      def initialize(str : String)
        parse_input str
      end

      def solved? : Bool
        false
      end
      
      def to_s(io : IO)
      end

      private def parse_input(input : String) 
        # puts "Input: #{input.lines}"
        lines = input.lines.map &.gsub(' ', '#').ljust(13, '#')
        #lines.each { |line| puts line }
        k = 0
        rooms = lines.map_with_index do |line,i|
          line.chars.map_with_index do |c,j|
            case c
            when '#'
              RoomType::Wall
            when '.'
              case j
              when 3,5,7,9
                RoomType::Hallway_No_Stop
              else
              RoomType::Hallway
              end
            when 'A','B','C','D'
              amphipodas<<Amphipoda.new(AmphipodaType::Amber + (c-'A'), {i, j} )
              room_type = RoomType::Room_A + k
              k = (k+1)%4
              room_type
            end
          end
        end
        rooms.each { |line| puts "#{line}"}
        amphipodas.each { |amp| puts "#{amp}"}
      end

    end

    def solution1(input) : Int32
      0
    end

    def solution2(input) : Int32
      0
    end

    def main
      input = Burrow.new(File.read "./src/day#{DAY}/input.txt")

      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
