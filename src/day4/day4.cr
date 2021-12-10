module AdventOfCode2021
  module Day4
    extend self

    DAY = 4

    # Bingo table. If one number is marked this number will be changed to Nil in this representation.
    alias Table = Array(Array(Int32?))
    alias Bingo = Tuple(Array(Int32), Array(Table))

    def parse_input(input : String) : Bingo
      mem = IO::Memory.new(input)
      numbers = mem.gets.not_nil!.split(',').map { |s| s.to_i32 }
      tables = parse_tables mem
      # p! numbers.size
      # p!({numbers, tables})
      {numbers, tables}
    end

    private def parse_tables(mem)
      tables = Array(Table).new
      while !mem.gets.nil?
        table = Table.new
        (1..5).each do
          table << mem.gets.not_nil!.strip.split(/\s+/).map { |s| s.to_i32.as(Int32?) }
        end
        tables << table
      end
      tables
    end

    def solution1(input : Array(Tuple(Int32, Int32, Int32)))
      step, number, sum = input.min_by { |step, _n, _sum| step }
      number * sum
    end

    def solution2(input : Array(Tuple(Int32, Int32, Int32)))
      step, number, sum = input.max_by { |step, _n, _sum| step }
      number * sum
    end

    def solve(table : Table, numbers : Array(Int32)) : Tuple(Int32, Int32, Int32)?
      (0...numbers.size).each do |i|
        sum = check_number_in_table(numbers[i], table)
        if !sum.nil?
          # p! table
          # p!({i,numbers[i],sum.not_nil!})
          return {i, numbers[i], sum.not_nil!}
        end
      end
    end

    private def check_number_in_table(n, t)
      # puts "Checking number #{n}"
      t.each do |line|
        j = line.index(n)
        if !j.nil?
          line[j] = nil
          if line.all? &.nil? || t.all? &.[j].nil?
            # p! t
            return t.sum &.sum { |v| v || 0 }
          end
        end
      end
    end

    def main
      numbers, tables = parse_input File.read "./src/day#{DAY}/input.txt"
      solved_tables = tables.map { |t| solve(t, numbers).not_nil! }
      puts "Solutions of day#{DAY} : #{solution1 solved_tables} #{solution2 solved_tables}"
    end
  end
end
