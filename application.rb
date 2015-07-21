require_relative 'map.rb'
require_relative 'solver.rb'
require_relative 'fileloader.rb'

class Application

  def initialize(filename)
    map = Fileloader.new(filename).map
    solver = Solver.new(map)
    solution = solver.solution
    puts "Final solution:"
    solution.display_print
  end
end
