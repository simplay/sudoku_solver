class Element

  attr_accessor :value, :candidates

  def initialize(value, row_idx, column_idx, map)
    @value = value
    @map = map
    @row_idx = row_idx
    @column_idx = column_idx
    @candidates = []
  end

  def unknown?
    @value.nil?
  end

  def to_s
    unknown? ? 'x' : @value.to_s
  end

  def elements_in_same_row
    @map.row_at(@row_idx)
  end

  def elements_in_same_column
    @map.column_at(@column_idx)
  end

  # Get all elements that belong to same 3x3 sudoku block.
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
