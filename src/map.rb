require_relative 'element.rb'

# A map acts as a 2 dimensional array where indexing starts counting at 0.
# It is possible to enumerate over a map instance.
class Map

  attr_accessor :width,
                :height

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

  # Retrieve all Elements that belong to row #row_idx
  #
  # @param row_idx [Integer] row index of target Element in this map.
  # @return [Array] of Element instances that belong to row #row_idx
  def row_at(row_idx)
    @grid[row_idx]
  end

  # Retrieve all Elements that belong to column #column_idx
  #
  # @param column_idx [Integer] column index of target Element in this map.
  # @return [Array] of Element instances that belong to column #column_idx
  def column_at(column_idx)
    (0..@height-1).map do |row_idx|
      element_at(row_idx, column_idx)
    end
  end

  # Set the value of the Element at position (#row_idx, #column_idx).
  #
  # @param row_idx [Integer] row index of target Element in this map.
  # @param column_idx [Integer] column index of target Element in this map.
  # @param value  [Integer] value of target Element in this map.
  def set_element_at(row_idx, column_idx, value)
    target_row = row_at(row_idx)
    element = Element.new(value, row_idx, column_idx, self)
    target_row[column_idx] = element
  end

  # Retrieve the Element at position (#row_idx, #column_idx).
  #
  # @param row_idx [Integer] row index of target Element in this map.
  # @param column_idx [Integer] column index of target Element in this map.
  # @return [Element] instance at given position.
  def element_at(row_idx, column_idx)
    target_row = row_at(row_idx)
    target_row[column_idx]
  end

  # Display values of Element instances in this Map.
  def display_print
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |element, column_idx|
        separator = (column_idx % 3 == 2) ? "   " : " "
        print element.to_s + separator
      end
      puts
      puts if (row_idx % 3 == 2)
    end
    nil
  end

  # Number of unknown (not yet solved) Element positions in this Map.
  #
  # @return [Integer] number of not solved Element positions in this Map.
  def unknown_count
    (select &:unknown?).count
  end

  private

  # Decrement a given value if not nil.
  #
  # @param prev_value [Integer] value to increment.
  def decremented_value_of(prev_value)
    @debug ? (prev_value-1) : nil
  end

end
