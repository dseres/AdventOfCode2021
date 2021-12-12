module AdventOfCode2021
  module Day10
    extend self

    DAY = 10

    @@points = {
      '(' => 1,
      '[' => 2,
      '{' => 3,
      '<' => 4,

      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137,
    }

    @@pairs = {
      ')' => '(',
      ']' => '[',
      '}' => '{',
      '>' => '<',
    }

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def solution1(input : Array(String)) : Int32
      input.sum do |line|
        result = parse_line line
        result.is_a?(Char) ? @@points[result.as(Char)] : 0
      end
    end

    private def parse_line(line) : Array(Char) | Char
      stack = [] of Char
      line.chars.each do |c|
        case c
        when ')', ']', '}', '>'
          pair = stack.pop
          if pair != @@pairs[c]
            return c
          end
        when '(', '[', '{', '<'
          stack.push c
        end
      end
      stack
    end

    def solution2(input : Array(String)) : Int64
      scores = input
        .map { |line| parse_line line }
        .select(&.is_a?(Array(Char)))
        .map(&.as(Array(Char)))
        .map { |stack| get_stack_points stack, 0 }
        .sort
      scores[scores.size // 2]
    end

    private def get_stack_points(stack, initial : Int64) : Int64
      if stack.empty?
        initial
      else
        next_value = initial * 5 + @@points[stack.pop]
        get_stack_points stack, next_value
      end
    end

    def main
      input = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
