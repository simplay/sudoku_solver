require 'set'

# An Element belongs to a Map. Each element has a value and a set of candidates.
# It is possible to query its sudoku-row-, -column- and -block-neighbors.
# Each Element is either in a known or unknown state.
class Element

  attr_accessor :value, :candidates

  # @param value [Integer] or [nil]
  # @param row_idx [Integer] row index of this Element in #map
  # @param column_idx [Integer] column index of this Element in #map
  # @param map [Map] instance where this Element is stored.
  def initialize(value, row_idx, column_idx, map)
    @value = value
    @map = map
    @row_idx = row_idx
    @column_idx = column_idx
    @candidates = unknown? ? (1..9).to_a.map(&:to_s) : []
  end

  # Does this Element have a known #value, i.e. its value is not nil.
  #
  # @return [Boolean] true if value known otherwise false.
  def unknown?
    @value.nil?
  end

  # Does this Element have only one possible candidate?
  # @return [Boolean] true if there is only one possible candidate.
  def one_candidate?
    @candidates.count == 1
  end

  # Assign a value to this Element and empty its candidate list.
  def set_final_value
    @value = @candidates.first
    @candidates = []
  end

  # Update candidate list by removing all impossible candidates.
  # @param impossible_candidates [Array] impossible candidate Element values.
  def update_candidates_from(impossible_candidates)
    @candidates = (Set.new(@candidates) - Set.new(impossible_candidates)).to_a
  end

  # Pretty String representation of value of this Element.
  #
  # @return [String] 'x' in case Element#value is unknown otherwise its value as string.
  def to_s
    unknown? ? 'x' : @value.to_s
  end

  # All Elements that live in the same row in @map as this Element does.
  #
  # @return [Array] of Element instances living in same row as this Element.
  def elements_in_same_row
    @map.row_at(@row_idx)
  end

  # All Elements that live in the same column in @map as this Element does.
  #
  # @return [Array] of Element instances living in same column as this Element.
  def elements_in_same_column
    @map.column_at(@column_idx)
  end

  # Get all elements that belong to same 3x3 sudoku block.
  #
  # @param region_size [Integer] block length.
  # @return [Array] of Element instances that belong to the same block.
  def elements_in_same_block(region_size = 3)
    row_del = @row_idx % region_size
    col_del = @column_idx % region_size

    region_shift = region_size -1

    start_row_idx = @row_idx - row_del
    start_col_idx = @column_idx - col_del

    block_elements = []
    (start_row_idx..start_row_idx+region_shift).each do |row_idx|
      (start_col_idx..start_col_idx+region_shift).each do |col_idx|
        block_elements << @map.element_at(row_idx, col_idx)
      end
    end
    block_elements
  end

end
