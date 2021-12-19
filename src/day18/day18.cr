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

      def self.zero
        SailfishNumber.new -1, -1, nil
      end

      def +(other : SailfishNumber) : SailfishNumber
        return self if other == SailfishNumber.zero
        return other if self == SailfishNumber.zero
        sum = SailfishNumber.new self.clone, other.clone
        sum.left.as(SailfishNumber).parent = sum
        sum.right.as(SailfishNumber).parent = sum
        sum.reduce
      end

      def reduce : SailfishNumber
        loop do
          search_for_explodes
          bad = find_first_node_to_split
          break if bad.nil?
          split(bad)
          # puts "after split:\t#{self}"
        end
        self
      end

      def search_for_explodes
        loop do
          bad = find_first_node_to_explode
          break if bad.nil?
          explode(bad)
          # puts "after explode:\t#{self}"
        end
      end

      def find_first_node_to_explode : SailfishNumber?
        find_first_node_to_explode self, 1
      end

      def find_first_node_to_explode(node : SailfishNumber, level : Int32) : SailfishNumber?
        return node if level > 4
        result = check_explode_on_child(node.left, level)
        return result unless result.nil?
        check_explode_on_child(node.right, level)
      end

      def check_explode_on_child(child : SailfishNumber | Int32, level : Int32) : SailfishNumber?
        return find_first_node_to_explode(child, level + 1) if child.is_a?(SailfishNumber)
      end

      def find_first_node_to_split : SailfishNumber?
        find_first_node_to_split self
      end

      def find_first_node_to_split(node : SailfishNumber) : SailfishNumber?
        result = check_split_on_child(node, node.left)
        return result unless result.nil?
        check_split_on_child(node, node.right)
      end

      def check_split_on_child(parent : SailfishNumber, child : SailfishNumber | Int32) : SailfishNumber?
        return parent if child.is_a?(Int32) && child > 9
        return find_first_node_to_split(child) if child.is_a?(SailfishNumber)
      end

      def explode(bad : SailfishNumber)
        sorted = sort_nodes_from_left_to_right
        reduce_node(bad, sorted)
      end

      private def sort_nodes_from_left_to_right
        sorted = [] of self
        sort_nodes_from_left_to_right(self, sorted)
        sorted
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
          node = nodes[index - 1]
          if node.right.is_a? self
            node.left = node.left.as(Int32) + value
          else
            node.right = node.right.as(Int32) + value
          end
        end
      end

      private def add_right_to_the_next(value : Int32, index : Int32, nodes : Array(SailfishNumber))
        if index < nodes.size - 1
          node = nodes[index + 1]
          if node.left.is_a? self
            node.right = node.right.as(Int32) + value
          else
            node.left = node.left.as(Int32) + value
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

      private def split(node : self)
        return if split_left_number(node)
        return if split_right_number(node)
      end

      private def split_left_number(node : self)
        left = node.left
        if left.is_a?(Int32) && left > 9
          node.left = SailfishNumber.new((left / 2).floor.to_i32, (left / 2).ceil.to_i32, node)
        end
      end

      private def split_right_number(node : self)
        right = node.right
        if right.is_a?(Int32) && right > 9
          node.right = SailfishNumber.new((right / 2).floor.to_i32, (right / 2).ceil.to_i32, node)
        end
      end

      def magnitude : Int32
        left = magnitude @left
        right = magnitude @right
        3 * left + 2 * right
      end

      private def magnitude(child : SailfishNumber | Int32) : Int32
        value = child.as?(Int32)
        return value unless value.nil?
        child = child.as(SailfishNumber)
        child.magnitude
      end
    end

    def parse_input(input : String) : Array(SailfishNumber)
      input.lines.map { |line| SailfishNumber.new(line) }
    end

    def solution1(numbers : Array(SailfishNumber)) : Int32
      numbers.sum.as(SailfishNumber).magnitude
    end

    def solution2(input : Array(SailfishNumber)) : Int32
      max = 0
      0.upto(input.size - 2) do |i|
        0.upto(input.size - 2) do |j|
          if i != j
            sum = input[i] + input[j]
            magnitude = sum.magnitude
            if max < magnitude
              max = magnitude
            end
          end
        end
      end
      max
    end

    def main
      numbers = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 numbers} #{solution2 numbers}"
    end
  end
end
