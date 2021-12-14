module AdventOfCode2021
  module Day14
    extend self

    DAY = 14

    def parse_input(input : String) : Tuple(String, Hash(String, Char))
      template, rules_str = input.split "\n\n"
      rules = Hash(String, Char).new
      rules_str.lines.each do |line|
        parts = line.split " "
        rules[parts[0]] = parts[2][0]
      end
      {template, rules}
    end

    def main
      template, rules = parse_input File.read "./src/day#{DAY}/input.txt"
      puts "Solutions of day#{DAY} : #{solution1 template, rules} #{solution2 template, rules}"
    end

    def solution1(template : String, rules : Hash(String, Char)) : UInt64
      compute template, rules, 10
    end

    def solution2(template : String, rules : Hash(String, Char)) : UInt64
      compute template, rules, 40
    end

    private def compute(polymer, rules, times)
      pairs = count_pairs polymer, rules
      times.times do
        pairs = next_pairs pairs, rules
      end
      chars = count_chars pairs
      chars[polymer[0]]+=1
      chars.max_of(&.[1]) - chars.min_of(&.[1])
    end

    private def count_pairs(polymer, rules)
      counter = rules.map { |pair, _c| {pair, 0.to_u64} }.to_h
      (0..polymer.size - 2).each do |i|
        part = polymer[i, 2]
        counter[part] += 1
      end
      counter
    end

    private def next_pairs(counters, rules)
      next_pairs = rules.map { |pair, _c| {pair, 0.to_u64} }.to_h
      counters.each do |pair, counter|
        next_pair1 = "#{pair[0]}#{rules[pair]}"
        next_pairs[next_pair1] += counter
        next_pair2 = "#{rules[pair]}#{pair[1]}"
        next_pairs[next_pair2] += counter
      end
      next_pairs
    end

    private def count_chars(pair_counters : Hash(String, UInt64))
      counters = Hash(Char, UInt64).new
      pair_counters.keys.each(&.chars.each { |c| counters[c] = 0 })
      pair_counters.each do |pair, counter|
        counters[pair[1]] += counter
      end
      counters
    end
  end
end
