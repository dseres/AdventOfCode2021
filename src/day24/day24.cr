module AdventOfCode2021
  module Day24
    extend self

    DAY = 24

    def break_lines(input : String)
      table = Array(String).new 18,"| "
      input.lines.each_with_index do |line,i|
        table[i%18] += line.ljust(9) + "|"
      end
      puts "|"+ (1..14).map{|i| "Program#{i}|"}.sum
      puts table[0].gsub(/[^|]/){"-"}
      table.each do |line|
        puts line
      end
    end

    def get_params(input : String)
      lines = input.lines
      params = Array(Array(Int32)).new(14){Array.new(3,0)}
      (0...14).each do |i|
        line1 = lines[i*18 + 4]
        line2 = lines[i*18 + 5]
        line3 = lines[i*18 + 15]
        params[i][0] = line1.split(' ')[2].to_i
        params[i][1] = line2.split(' ')[2].to_i
        params[i][2] = line3.split(' ')[2].to_i
      end
      params
    end

    def parse_input(input : String) : Array(String)
      input.lines
    end

    def compute_largest(params : Array(Array(Int32)), iteration : Int32, state : Hash(Int64, Int64)) : Hash(Int64, Int64)
      new_state = Hash(Int64, Int64).new
      param1,param2, param3 = params[iteration-1]
      #pp! param1,param2, param3 
      state.each do |prev_z,prev_input|
        #inputs:
        (1..9).each do |input|
          x = ( ( prev_z % 26 + param2) == input ? 0 : 1 )
          z = prev_z // param1 * (25 * x + 1)
          y = ( input + param3 ) * x
          z = z + y
          #pp! x,y,z
          new_state[z] = prev_input * 10 + input
        end
      end
      puts "Iteration : #{iteration}, number of states : #{state.size}"
      return new_state if iteration == 14
      return compute_largest params, iteration + 1, new_state
    end

    def compute_smallest(params : Array(Array(Int32)), iteration : Int32, state : Hash(Int64, Int64)) : Hash(Int64, Int64)
      new_state = Hash(Int64, Int64).new
      param1,param2, param3 = params[iteration-1]
      #pp! param1,param2, param3 
      state.each do |prev_z,prev_input|
        #inputs:
        (1..9).reverse_each do |input|
          x = ( ( prev_z % 26 + param2) == input ? 0 : 1 )
          z = prev_z // param1 * (25 * x + 1)
          y = ( input + param3 ) * x
          z = z + y
          #pp! x,y,z
          new_state[z] = prev_input * 10 + input
        end
      end
      puts "Iteration : #{iteration}, number of states : #{state.size}"
      return new_state if iteration == 14
      return compute_smallest params, iteration + 1, new_state
    end

    def solution1(input) : Int64
      params = get_params input
      states = compute_largest params, 1, { 0_i64 => 0_i64}
      states[0]
    end

    def solution2(input) : Int64
      params = get_params input
      states = compute_smallest params, 1, { 0_i64 => 0_i64}
      states[0]
    end


    def main
      input = File.read "./src/day#{DAY}/input.txt"
      #break_lines input
      #params = get_params input
      puts "Solutions of day#{DAY} : #{solution1 input} #{solution2 input}"
    end
  end
end
