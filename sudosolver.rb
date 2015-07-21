require_relative 'map.rb'
require_relative 'solver.rb'
require_relative 'fileloader.rb'
require 'pry'
map = Fileloader.new("m1.txt").map
solver = Solver.new(map)
solution = solver.solution
puts "Final solution:"
solution.display_print
