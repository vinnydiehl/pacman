class PacMan
  def render_game
    render_background ####### for debug;
    render_map ############## these will be static renders
    render_debug
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
    @cell_size = @screen_height / @grid_height
    @grid_px_width = @grid_width * @cell_size
    @grid_px_height = @grid_height * @cell_size
    @grid_start_x = (@screen_width / 2) - (@grid_px_width / 2)

    ############### Debug
    colors = {
      outer_wall: { r: 0, g: 0, b: 255 },
      inner_wall: { r: 0, g: 0, b: 200 },
      ghost_house_wall: { r: 0, g: 0, b: 150 },
    }

    @grid.each_with_index do |column, x|
      column.each_with_index.filter { |c, _| c[:type].to_s.include?("wall") }.each do |cell, y|
        neighbors = {
          above_left: x > 0 && y > 0 && @grid[x - 1][y - 1][:walkable],
          above: x > 0 && @grid[x - 1][y][:walkable],
          above_right: x > 0 && y < @grid_height - 1 && @grid[x - 1][y + 1][:walkable],
          left: y > 0 && @grid[x][y - 1][:walkable],
          right: y < @grid_height - 1 && @grid[x][y + 1][:walkable],
          below_left: x < @grid_width - 1 && y > 0 && @grid[x + 1][y - 1][:walkable],
          below: x < @grid_width - 1 && @grid[x + 1][y][:walkable],
          below_right: x < @grid_width - 1 && y < @grid_height - 1 && @grid[x + 1][y + 1][:walkable],
        }

        wall_type, rotation = determine_wall_sprite_and_rotation(cell[:walkable], neighbors)
        puts <<~EOS
          (#{x}, #{y}): #{wall_type}, rot: #{rotation}
        EOS
      end
    end

    @grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        cell[:sprite] = {
          primitive_marker: :solid,
          x: @grid_start_x + (x * @cell_size),
          y: y * @cell_size,
          w: @cell_size, h: @cell_size,
          **(colors[cell[:type]] || {}),
        }
      end
    end
  end

  def determine_wall_sprite_and_rotation(cell, neighbors)
    # Define the different wall sprite configurations based on neighboring cells
    wall_sprites = {
      straight: [
        [true, false, true],
        [false, false, false],
        [true, false, true]
      ],
      convex_corner: [
        [false, false, true],
        [false, false, true],
        [true, true, true]
      ],
      concave_corner: [
        [false, false, false],
        [false, false, false],
        [false, false, true]
      ],
    }

    # Check the configuration of neighboring cells
    configuration = [
      [neighbors[:above_left], neighbors[:above], neighbors[:above_right]],
      [neighbors[:left], cell, neighbors[:right]],
      [neighbors[:below_left], neighbors[:below], neighbors[:below_right]]
    ]

    wall_type = nil
    rotation = 0

    wall_sprites.each do |type, pattern|
      rotation = 0

      if configuration == pattern
        wall_type = type
        break
      else
        3.times do
          # Try rotating the pattern (CCW) to match the configuration
          rotation += 90
          pattern = pattern.map(&:reverse).transpose
          if configuration == pattern
            wall_type = type
            break
          end
        end
      end
    end

    return wall_type, rotation
  end

  def render_map
    @grid.flatten.each do |cell|
      @primitives << cell[:sprite]
    end
  end

  def render_debug
    # Grid
    grid_color = { r: 0, g: 150, b: 0 }
    (@grid_height + 1).times do |y|
      @primitives << {
        x: @grid_start_x,
        y: y * @cell_size,
        x2: @grid_start_x + @grid_px_width,
        y2: y * @cell_size,
        **grid_color,
      }
    end
    (@grid_width + 1).times do |x|
      @primitives << {
        x: @grid_start_x + (x * @cell_size),
        y: 0,
        x2: @grid_start_x + (x * @cell_size),
        y2: @grid_px_height,
        **grid_color,
      }
    end
  end
end
