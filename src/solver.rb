class Solver
  attr_accessor :solution

  def initialize(map)
    @solution = map
    solve_map
  end

  private

  def solve_map
    unknowns = @solution.unknown_count
    iter_count = 0
    begin
      iter_count = iter_count + 1
      prev_unknown_count = unknowns
      @solution.each do |element|
        # update candidate list
        if element.unknown?
          solve_candidates_for(element)
          element.set_final_value if element.one_candidate?
        end
      end
      unknowns = @solution.unknown_count
    end while(unknowns != prev_unknown_count)
    puts "processed #{iter_count} iterations exhibiting #{unknowns} unknown(s)"
  end

  def solve_candidates_for(element)
    known_row_values = (element.elements_in_same_row.map &:value).compact
    element.update_candidates_from(known_row_values)

    known_column_values = (element.elements_in_same_column.map &:value).compact
    element.update_candidates_from(known_column_values)

    known_block_values = (element.elements_in_same_block.map &:value).compact
    element.update_candidates_from(known_block_values)
  end
end
