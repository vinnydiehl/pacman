class PacMan
  def render_game
    render_background ####### for debug;
    render_map ############## these will be static renders
  end

  def render_background
    @primitives << {
      primitive_marker: :solid,
      x: 0, y: 0,
      w: @screen_width, h: @screen_height,
      r: 0, g: 0, b: 0,
    }
  end

  def load_map
    cell_size = @screen_height / @grid_height
    grid_px_width = @grid_width * cell_size
    grid_start_x = (@screen_width / 2) - (grid_px_width / 2)

    colors = {
      outer_wall: { r: 0, g: 0, b: 255 },
      inner_wall: { r: 0, g: 0, b: 200 },
      ghost_house_wall: { r: 0, g: 0, b: 150 },
    }

    @grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        cell[:sprite] = {
          primitive_marker: :solid,
          x: grid_start_x + (x * cell_size),
          y: y * cell_size,
          w: cell_size, h: cell_size,
          **(colors[cell[:type]] || {}),
        }
      end
    end
  end

  def render_map
    @grid.flatten.each do |cell|
      @primitives << cell[:sprite]
    end
  end
end
