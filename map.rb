require_relative 'element.rb'

# A map acts as a 2 dimensional array.
# Indexing starts counting at 0.
class Map

  attr_accessor :width, :height, :grid

  include Enumerable

  # Create a 2d array with (width X height) elements.
  #
  # @param width [Integer] number of elements in width.
  # @param height [Integer] number of elements in height.
  # @param debug [Boolean] fill with dummy values otherwise filled with nil.
  def initialize(width, height, debug=false)
    @grid = []
    @width = width; @height = height
    @debug = debug
    debug_counter = debug ? 0 : nil
    height.times do |row_idx|
      line = []
      width.times do |column_idx|
        debug_counter = decremented_value_of(debug_counter)
        line << Element.new(debug_counter, row_idx, column_idx, self)
      end
      @grid << line
    end
  end

  def each(&block)
    @grid.each do |row|
      row.each do |element|
        if block_given?
          block.call element
        else
          yield element
        end
      end
    end
  end

  def row_at(row_idx)
    @grid[row_idx]
  end

  def column_at(column_idx)
    (0..@height-1).map do |row_idx|
      element_at(row_idx, column_idx)
    end
  end

  def set_element_at(row_idx, column_idx, value)
    target_row = row_at(row_idx)
    element = Element.new(value, row_idx, column_idx, self)
    target_row[column_idx] = element
  end

  def element_at(row_idx, column_idx)
    target_row = row_at(row_idx)
    target_row[column_idx]
  end

  def display_print
    @grid.each do |row|
      row.each do |element|
        print element.to_s + " "
      end
      puts
    end
    nil
  end

  def unknown_count
    (select &:unknown?).count
  end

  private

  def decremented_value_of(prev_value)
    @debug ? (prev_value-1) : nil
  end

end
