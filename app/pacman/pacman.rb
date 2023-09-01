# Constructor and main #tick method for the game runner class which is set
# to `args.state.game` in `main.rb`.
class PacMan
  def initialize(args)
    @args = args
    @state = args.state

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @inputs = args.inputs

    # Outputs
    @debug = args.outputs.debug
    @sounds = args.outputs.sounds
    @primitives = args.outputs.primitives
    @static_primitives = args.outputs.static_primitives

    @scene_stack = []
    self.scene = :game
  end

  def tick
    # Inputs
    @kb_inputs = @inputs.keyboard.key_down
    @kb_inputs_held = @inputs.keyboard.key_held
    @c1_inputs = @inputs.controller_one.key_down
    @c1_inputs_held = @inputs.controller_one.key_held

    # Reset game, for development
    if inputs_any?(kb: :backspace, c1: :select)
      @args.gtk.reset
    end

    # Save this so that even if the scene changes during the tick, it is
    # still rendered before switching scenes.
    scene = @scene
    send "#{scene}_tick"
    send "render_#{scene}"
  end

  # Pushes a scene onto the scene stack.
  def scene=(scene)
    @scene = scene
    @scene_stack << scene

    init_method = :"#{@scene}_init"
    send init_method if self.class.method_defined?(init_method)
  end

  # Pops the last scene off the scene stack, setting the scene to the
  # previous one.
  def pop_scene
    @scene_stack.pop
    @scene = @scene_stack.last
  end
end
