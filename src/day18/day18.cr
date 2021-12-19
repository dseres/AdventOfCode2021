require "json"

module AdventOfCode2021
  module Day18
    extend self

    DAY = 18

    class SailfishNumber
      # Sailfish number can be included recursively on 5 level
      # alias SnArray = Array(Array(Array(Array(Array(Int32) | Int32) | Int32) | Int32) | Int32)

      alias SnArray = Array(Int32 | SnArray)

      property left : Int32 | SailfishNumber = 0
      property right : Int32 | SailfishNumber = 0
      property parent : SailfishNumber? = nil

      def initialize(@left : Int32 | SailfishNumber, @right : Int32 | SailfishNumber, @parent : SailfishNumber? = nil)
      end

      def initialize(str : String)
        any = JSON.parse str # parse as json
        build_tree any
      end

      def initialize(any : JSON::Any)
        build_tree any
      end

      private def build_tree(any)
        # pp! any
        any = any.as_a
        if !any[0].as_a?
          @left = any[0].as_i
        else
          @left = SailfishNumber.new(any[0])
        end
        if !any[1].as_a?
          @right = any[1].as_i
        else
          @right = SailfishNumber.new(any[1])
        end
      end

      def to_s(io)
        io << "[" << left << "," << right << "]"
      end

      def ==(other : SailfishNumber) : Bool
        @left == other.left && @right == other.right
      end

      def ==(other) : Bool
        false
      end

      def clone : SailfishNumber
        n = SailfishNumber.new @left, @right
        if @left.is_a? SailfishNumber
          n.left = @left.clone
        end
        if @right.is_a? SailfishNumber
          n.right = @right.clone
        end
        n
      end

      def +(other : SailfishNumber) : SailfishNumber
        sum = SailfishNumber.new self.clone, other.clone
        sum.left.as(SailfishNumber).parent = sum
        sum.right.as(SailfishNumber).parent = sum
        sum
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
