# Methods related to user input.
class PacMan
  # For detecting button presses. Use like so:
  #
  #   inputs_any? kb: %i[space enter], c1: %i[a b]
  #
  # The above example allows wither space or enter on the keyboard, or
  # either A or B on a controller.
  def inputs_any?(**inputs)
    # Support for either single or array input for the value
    inputs.each { |k, v| inputs[k] = [v].flatten }

    inputs[:kb]&.any? { |input| @kb_inputs.send input } ||
      inputs[:c1]&.any? { |input| @c1_inputs.send input }
  end
end
