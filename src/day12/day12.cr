module AdventOfCode2021
  module Day12
    extend self

    DAY = 12

    class TroglodyticSystem
      alias Graph = Hash(String, Array(String))
      getter graph = Graph.new
      getter pathes : Array(Array(String)) | Nil = nil
      getter pathes2 : Array(Array(String)) | Nil = nil

      def initialize(input : String)
        parse_input input
      end

      private def parse_input(input)
        input.lines.map(&.split('-')).each do |nodes|
          a, b = nodes
          graph[a] ||= Array(String).new
          graph[a] << b
          graph[b] ||= Array(String).new
          graph[b] << a
        end
      end

      def compute_pathes
        @pathes ||= add_next_nodes(["start"]).select { |p| p.last == "end" }.sort.uniq
      end

      def compute_pathes2
        @pathes2 ||= add_next_nodes(["start"], allow_twice: true).select { |p| p.last == "end" }.sort.uniq
      end

      private def add_next_nodes(path, allow_twice = false, visited_twice = false)
        next_pathes = [path]
        graph[path.last].each do |cave|
          if is_next_cave_viable(path, allow_twice, visited_twice, cave)
            next_visited_twice = visited_twice || ('a' <= cave[0] && cave[0] <= 'z') && allow_twice && !(path.index(cave).nil?)
            next_path = path.dup + [cave]
            next_pathes.concat add_next_nodes(next_path, allow_twice: allow_twice, visited_twice: next_visited_twice)
          end
        end
        next_pathes
      end

      private def is_next_cave_viable(path, allow_twice, visited_twice, cave)
        ('A' <= cave[0] && cave[0] <= 'Z') || ('a' <= cave[0] && cave[0] <= 'z') && (path.index(cave).nil? || allow_twice && !visited_twice && cave != "end" && cave != "start")
      end
    end

    def main
      input = File.read "./src/day#{DAY}/input.txt"
      ts = TroglodyticSystem.new(input)
      puts "Solutions of day#{DAY} : #{ts.compute_pathes.size} #{ts.compute_pathes2.size}"
    end
  end
end
