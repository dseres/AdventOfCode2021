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
        # !pp str
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
          @left.as(SailfishNumber).parent = self
        end
        if !any[1].as_a?
          @right = any[1].as_i
        else
          @right = SailfishNumber.new(any[1])
          @right.as(SailfishNumber).parent = self
        end
      end

      def to_s(io)
        io << "[" << left << "," << right << "]"
      end

      def clone : SailfishNumber
        n = SailfishNumber.new @left, @right, @parent
        if @left.is_a? SailfishNumber
          n.left = @left.clone
          n.left.as(SailfishNumber).parent = n
        end
        if @right.is_a? SailfishNumber
          n.right = @right.clone
          n.right.as(SailfishNumber).parent = n
        end
        n
      end

      def ==(other : SailfishNumber)
        parent_check = parent.nil? && other.parent.nil? || !parent.nil? && !other.parent.nil?
        parent_check && @left == other.left && @right == other.right
      end

      def ==(other)
        false
      end

      def +(other : SailfishNumber) : SailfishNumber
        sum = SailfishNumber.new self.clone, other.clone
        sum.left.as(SailfishNumber).parent = sum
        sum.right.as(SailfishNumber).parent = sum
        # sum.reduce
        sum
      end

      def reduce : SailfishNumber
        while reduce_by_depth || reduce_by_numbers
        end
        self
      end

      def reduce_by_depth : Bool
        ns2r = find_nodes_to_reduce 1
        if !ns2r.empty?
          sorted = [] of self
          sort_nodes_from_left_to_right(self, sorted)
          ns2r.each { |node| reduce_node(node, sorted) }
        end
        !ns2r.empty?
      end

      def find_nodes_to_reduce(depth : Int32) : Array(SailfishNumber)
        nodes = [] of SailfishNumber
        if depth <= 4
          if @left.is_a? SailfishNumber
            nodes += @left.as(SailfishNumber).find_nodes_to_reduce(depth + 1)
          end
          if @right.is_a? SailfishNumber
            nodes += @right.as(SailfishNumber).find_nodes_to_reduce(depth + 1)
          end
        else
          nodes << self
        end
        nodes
      end

      private def sort_nodes_from_left_to_right(node : SailfishNumber, nodes : Array(SailfishNumber))
        if node.left.is_a? SailfishNumber
          sort_nodes_from_left_to_right(node.left.as(self), nodes)
        end
        if node.left.is_a?(Int32) || node.right.is_a?(Int32)
          nodes << node
        end
        if node.right.is_a? SailfishNumber
          sort_nodes_from_left_to_right(node.right.as(self), nodes)
        end
      end

      private def reduce_node(node : SailfishNumber, nodes : Array(SailfishNumber))
        index = nodes.index { |n| n.object_id == node.object_id }.not_nil!
        lno = node.left.as(Int32)
        rno = node.right.as(Int32)
        add_left_to_the_previous(lno, index, nodes)
        add_right_to_the_next(rno, index, nodes)
        replace_with_zero node
      end

      private def add_left_to_the_previous(value : Int32, index : Int32, nodes : Array(SailfishNumber))
        if index > 0
          if nodes[index - 1].right.is_a? self
            nodes[index - 1].left = nodes[index - 1].left.as(Int32) + value
          else
            nodes[index - 1].right = nodes[index - 1].right.as(Int32) + value
          end
        end
      end

      private def add_right_to_the_next(value : Int32, index : Int32, nodes : Array(SailfishNumber))
        if index < nodes.size - 1
          if nodes[index + 1].left.is_a? self
            nodes[index + 1].right = nodes[index + 1].right.as(Int32) + value
          else
            nodes[index + 1].left = nodes[index + 1].left.as(Int32) + value
          end
        end
      end

      private def replace_with_zero(node : SailfishNumber)
        parent = node.parent
        if !parent.nil?
          if parent.left == node
            parent.left = 0
          elsif parent.right == node
            parent.right = 0
          end
        end
      end

      private def reduce_by_numbers
        false
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
