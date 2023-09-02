class PacMan
  def game_init
    cells = {
      "`" => {
        type: :empty,
        walkable: true,
      },
      "." => {
        type: :dot,
        walkable: true,
      },
      "o" => {
        type: :power_pellet,
        walkable: true,
      },

      "+" => {
        type: :outer_wall,
        walkable: false,
      },
      "X" => {
        type: :inner_wall,
        walkable: false,
      },
      "H" => {
        type: :ghost_house_wall,
        walkable: false,
      },
      "-" => {
        type: :ghost_house_inside,
        walkable: false,
      },
      "=" => {
        type: :ghost_house_door,
        walkable: false,
      },
    }.freeze

    @grid = @args.gtk.read_file("data/grid.dat").split("\n").map do |line|
      line.chars.map do |ch|
        cells[ch].dup
      end
    end

    # Rotate so that cell (0, 0) is at the bottom-left
    @grid = @grid.transpose.map(&:reverse)

    @grid_width = @grid.length
    @grid_height = @grid.first.length

    load_map
  end

  def game_tick; end
end
