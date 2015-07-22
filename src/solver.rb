# Traverse each element's neighborhood and update its candidate list.
# If ther is only one candidate left, we have found a solution for the current Element#value.
class Solver
  attr_accessor :solution

  APPLY_BACKTRACKING = true

  # Solves a given sudoku represented as a Map instance.
  #
  # @param map [Mao] our target sudoku map (unsolved).
  def initialize(map)
    @solution = map
    solve_map
  end

  private

  # Iterate over whole Map and solve for each Element until convergence.
  # First update the possible candidates for each element.
  # In case there is only one possible candidate for a element in the map,
  # update its unknown value to this candidate value.
  # Repeat until the map is solved or there happens no update anymore.
  def solve_map
    unknowns = @solution.unknown_count
    iter_count = 0
    # binding.pry
    begin
      iter_count = iter_count + 1
      prev_unknown_count = unknowns
      at_least_one_element_modified = false
      was_backtracking = false
      @solution.each do |element|
        if element.unknown?
          were_candidates_modified = solve_candidates_for(element)
          element.set_final_value if element.one_candidate?
        end
        at_least_one_element_modified = true if were_candidates_modified
      end
      unknowns = @solution.unknown_count
      should_still_iterate = (unknowns != prev_unknown_count) || at_least_one_element_modified

      was_backtracking = perform_backtracking_step if backracking_required?(should_still_iterate)


      if !!@retry_req
        # was_backtracking = true #hack
        puts "should reset the prev state and try another value"
      end

    end while(should_still_iterate || was_backtracking)
    puts "processed #{iter_count} iterations exhibiting #{unknowns} unknown(s)"
  end

  # Backtracking is required if not every map element has been solved AND
  # the solver does report to stop iterating.
  #
  # @return [Boolean] true if sudoku has not been solved but the solver does not want to iterate anymore.
  def backracking_required?(should_still_iterate)
    !@solution.solved? && !should_still_iterate
  end

  # CURRENTLY NOT WORKING CORRECLY
  #
  # just quessing (brute-force) one possible solution.
  # Not correctly working yet. Add a remeber list of tried configuration.
  # Disallow to retry these already used configurations. Repeat until all possible
  # configurations ahve been tried.
  def perform_backtracking_step
    return false unless APPLY_BACKTRACKING
    a_two_candidates_element = @solution.elements_with_two_candidates.first

    @retry_req = a_two_candidates_element.nil?
    unless @retry_req
      a_two_candidates_element.try_guessed_candidate
      puts "backtracking should be performed"
      return true
    end
    false
  end

  # Update the candidate list of a given #element in @map
  # by iterating over its row-, column-, and block-neighbors and checking for values already set.
  # All values that already exist (within range 1-9) cannot be assigned to the current element#value anymore.
  #
  # @param element [Element] current instance we want to update its candidates.
  # @return [Boolean] did this element's candidate list got modified? True if yes otherwise false.
  def solve_candidates_for(element)
    known_row_values = (element.elements_in_same_row.map &:value).compact
    row_check_changed_candidates = element.update_candidates_from(known_row_values)

    known_column_values = (element.elements_in_same_column.map &:value).compact
    col_check_changed_candidates = element.update_candidates_from(known_column_values)

    known_block_values = (element.elements_in_same_block.map &:value).compact
    block_check_changed_candidates = element.update_candidates_from(known_block_values)

    row_check_changed_candidates || col_check_changed_candidates || block_check_changed_candidates
  end
end
