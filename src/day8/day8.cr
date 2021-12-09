module AdventOfCode2021
  module Day8
    extend self

    NUMBER = 8

    def parse_input(input : String)
      input.lines.map do |line|
        line.split(/[\s|]+/).map do |str|
          str.chars.sort.join
        end
      end
      # nput.lines.map &.split(/[\s|]+/)
    end

    def solution1(input : Array(Array(String))) : Int32
      input.sum do |line|
        line[10..13].count do |str|
          size = str.size
          size == 2 || size == 3 || size == 4 || size == 7
        end
      end
    end

    def solution2(input : Array(Array(String))) : Int32
      input.sum do |signals|
        # p! signals[0..9].map{ |signal| signal.size }.sort
        chars = solve signals
        get_number signals, chars
      end
    end

    private def solve(signals) : Hash(Char, Char)
      # p! signals
      chars = Hash( (String | Char), Array(Char)).new # chars of a display, e.g. abcdefg
      compute_segment_groups signals, chars
      compute_segments signals, chars
      chars.select { |c, _v| c.is_a? Char }.map { |c, chars| {chars[0], c.as(Char)} }.to_h
    end

    private def compute_segment_groups(signals, chars)
      # Number 1 with 2 segments  c,f
      signals.select { |s| s.size == 2 }.each do |s|
        chars["cf"] = s.chars
      end
      # Number 7 with 3 segments, a,c,f
      signals.select { |s| s.size == 3 }.each do |s|
        chars["acf"] = s.chars
      end
      # Number 0,6,8 with 6 segments -> a,b,f,g
      chars["abfg"] = signals.select(&.size.== 6).map(&.chars).reduce { |chars1, chars2| chars1 & chars2 }
      # Number 4 with 4 segments, b,c,d,f
      signals.select { |s| s.size == 4 }.each do |s|
        chars["bcdf"] = s.chars
      end
      # Number 2,3,5 with 5 segments -> a,d,g
      chars["adg"] = signals.select(&.size.== 5).map(&.chars).reduce { |chars1, chars2| chars1 & chars2 }
    end

    private def compute_segments(signals, chars)
      # We have 'c','f'
      chars['f'] = chars["cf"] & chars["abfg"]
      chars['c'] = chars["cf"] - chars['f']
      # we have the 'a'
      chars['a'] = chars["acf"] - chars["cf"]
      chars["bd"] = chars["bcdf"] - chars["cf"]
      chars['d'] = chars["bd"] & chars["adg"]
      chars['b'] = chars["bd"] - chars['d']
      # we have 'e'
      chars['e'] = "abcdefg".chars - chars["abfg"] - chars["bcdf"]
      # we have 'g'
      chars['g'] = "abcdefg".chars - chars['a'] - chars['b'] - chars['c'] - chars['d'] - chars['e'] - chars['f']
      # p! chars
    end

    private def get_number(signals, chars) : Int32
      number = 0
      signals[10..13].each do |s|
        digit = get_digit s, chars
        number = number * 10 + digit
      end
      number
    end

    # Numbers' representation from 0..9
    @@numbers = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]

    private def get_digit(s, chars)
      decoded = s.chars.map { |c| chars[c] }.sort.join
      @@numbers.index(decoded).not_nil!
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
