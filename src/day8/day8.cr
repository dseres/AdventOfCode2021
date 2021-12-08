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
        chars = solve_signals signals
        get_number signals, chars
      end
    end

    private def solve_signals(signals)
      # p! signals
      chars = Hash(String | Char, Array(Char)).new # chars of a display, e.g. abcdefg
      # Number 1 with 2 segments  c,f
      signals.select { |s| s.size == 2 }.each do |s|
        chars["cf"] = s.chars
      end
      # Number 0,6,8 with 9 segments -> a,b,f,g
      chars["abfg"] = signals.select { |s| s.size == 6 }.map { |s| s.chars }.reduce { |intersect, signal| intersect & signal }
      # We have 'c','f'
      chars['f'] = chars["cf"] & chars["abfg"]
      chars['c'] = chars["cf"] - chars['f']
      # Number 7 with 3 segments, a,c,f
      signals.select { |s| s.size == 3 }.each do |s|
        # we have the 'a'
        chars["acf"] = s.chars
        chars['a'] = chars["acf"] - chars["cf"]
      end
      # Number 4 with 4 segments, b,c,d,f
      signals.select { |s| s.size == 4 }.each do |s|
        # two possible value for 'b','d'
        chars["bcdf"] = s.chars
        chars["bd"] = chars["bcdf"] - chars["cf"]
      end
      # Number 2,3,5 with 5 segments -> a,d,g
      chars["adg"] = signals.select { |s| s.size == 5 }.map { |s| s.chars }.reduce { |intersect, signal| intersect & signal }
      chars['d'] = chars["bd"] & chars["adg"]
      chars['b'] = chars["bd"] - chars['d']
      # we have 'e'
      chars['e'] = "abcdefg".chars - chars["abfg"] - chars["bcdf"]
      # we have 'g'
      chars['g'] = "abcdefg".chars - chars['a'] - chars['b'] - chars['c'] - chars['d'] - chars['e'] - chars['f']
      # p! chars
      chars.select { |c, _v| c.is_a? Char }.map { |c, chars| Tuple.new(chars[0].as(Char), c.as(Char)) }.to_h
    end

    private def get_number(signals, chars) : Int32
      numbers = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
      number = 0
      signals[10..13].each do |s|
        # p! chars, numbers, s
        encoded = s.chars.map { |c| chars[c] }.sort.join
        # p! encoded
        digit = numbers.index(encoded).not_nil!
        # p! digit
        number = number * 10 + digit
      end
      number
    end

    def main
      input = parse_input File.read "./src/day#{NUMBER}/input.txt"
      puts "Solutions of day#{NUMBER} : #{solution1 input} #{solution2 input}"
    end
  end
end
