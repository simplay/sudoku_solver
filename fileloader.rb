require_relative 'map.rb'
class Fileloader

  attr_reader :map

  PLACEHOLDER = 'x'

  # @param filename [String] name of sudoku txt file stored in maps/
  # @example filename #=> 'm1.txt'
  def initialize(filename)
    @map = Map.new(9,9)
    sudoku_file = File.open("maps/#{filename}", 'r')
    line_idx = 0
    sudoku_file.each_line do |line|
      line.split.each_with_index do |token, item_idx|
        map.set_element_at(line_idx, item_idx, token) unless token==PLACEHOLDER
      end
      line_idx = line_idx + 1
    end
  end
end
