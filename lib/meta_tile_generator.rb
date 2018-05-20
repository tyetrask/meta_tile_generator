require 'chunky_png'

class MetaTileGenerator

  attr_accessor :tile_width
                :tile_height
                :meta_tile_width
                :meta_tile_height
                :base_tileset_width
                :base_tileset_height
                :generated_tileset_width
                :generated_tileset_height

  def initialize(tile_width)
    @tile_width = tile_width
    @tile_height = tile_width
    @meta_tile_width = @tile_width / 2
    @meta_tile_height = @tile_height / 2
    @base_tileset_width = @tile_width * 3
    @base_tileset_height = @tile_height * 2
    @generated_tileset_width = @tile_width * 8
    @generated_tileset_height = @tile_height * 6
  end

  def meta_tiles_from(image_filepath, x_offset=nil, y_offset=nil)
    base_tileset = base_tileset_for(image_filepath, x_offset, y_offset)
    meta_tiles = {}
    meta_tile_positions.each_with_index do |x_y_position, index|
      x, y = x_y_position
      tile = base_tileset.crop(x, y, @meta_tile_width, @meta_tile_height)
      meta_tiles["tile_#{index}"] = tile
    end
    meta_tiles
  end

  def create_tileset_from(image_filepath,  x_offset, y_offset)
    meta_tiles = meta_tiles_from(image_filepath, x_offset, y_offset)
    generated_tileset = ChunkyPNG::Image.new(@generated_tileset_width, @generated_tileset_height)
    cursor = {x: 0, y: 0}
    generated_tile_combinations.each do |metatiles|
      upper_left, upper_right, lower_left, lower_right = metatiles
      new_tile = ChunkyPNG::Image.new(@tile_width, @tile_height)
      new_tile.compose!(meta_tiles[upper_left], 0, 0)
      new_tile.compose!(meta_tiles[upper_right], @meta_tile_width, 0)
      new_tile.compose!(meta_tiles[lower_left], 0, @meta_tile_height)
      new_tile.compose!(meta_tiles[lower_right], @meta_tile_width, @meta_tile_height)
      generated_tileset.compose!(new_tile, cursor[:x], cursor[:y])
      cursor[:x] += @tile_width
      if cursor[:x] >= @generated_tileset_width
        cursor[:x] = 0
        cursor[:y] += @tile_height
      end
    end
    generated_tileset
  end

  def self.save_image(image, output_filepath)
    image.to_datastream.save(output_filepath)
  end

  private

  def base_tileset_for(image_filepath, x_offset, y_offset)
    base_tileset = ChunkyPNG::Image.from_file(image_filepath)
    if x_offset && y_offset
      base_tileset.crop!(x_offset, y_offset, @base_tileset_width, @base_tileset_height)
    end
    base_tileset
  end

  def meta_tile_positions
    [
      [0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0],
      [0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1],
      [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2],
      [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3]
    ].map do |coordinates|
      x, y = coordinates
      [x * @meta_tile_width, y * @meta_tile_height]
    end
  end

  def generated_tile_combinations
    [
      # Row 0
      ["tile_16", "tile_17", "tile_22", "tile_23"],
      ["tile_0", "tile_3", "tile_18", "tile_21"],
      ["tile_6", "tile_9", "tile_12", "tile_15"],
      ["tile_1", "tile_2", "tile_19", "tile_20"],
      ["tile_0", "tile_1", "tile_6", "tile_11"],
      ["tile_12", "tile_5", "tile_18", "tile_19"],
      ["tile_4", "tile_9", "tile_20", "tile_21"],
      ["tile_1", "tile_3", "tile_10", "tile_15"],
      # Row 1
      ["tile_0", "tile_3", "tile_6", "tile_15"],
      ["tile_0", "tile_1", "tile_18", "tile_20"],
      ["tile_12", "tile_9", "tile_18", "tile_21"],
      ["tile_2", "tile_3", "tile_19", "tile_21"],
      ["tile_0", "tile_1", "tile_12", "tile_7"],
      ["tile_6", "tile_8", "tile_18", "tile_19"],
      ["tile_14", "tile_15", "tile_20", "tile_21"],
      ["tile_2", "tile_3", "tile_8", "tile_9"],
      # Row 2
      ["tile_4", "tile_15", "tile_10", "tile_9"],
      ["tile_2", "tile_1", "tile_10", "tile_11"],
      ["tile_12", "tile_5", "tile_6", "tile_11"],
      ["tile_4", "tile_5", "tile_20", "tile_19"],
      ["tile_4", "tile_5", "tile_10", "tile_11"],
      ["tile_4", "tile_5", "tile_14", "tile_11"],
      ["tile_7", "tile_5", "tile_10", "tile_11"],
      ["tile_13", "tile_5", "tile_7", "tile_11"],
      # Row 3
      ["tile_14", "tile_15", "tile_10", "tile_15"],
      ["tile_1", "tile_1", "tile_14", "tile_11"],
      ["tile_12", "tile_13", "tile_6", "tile_11"],
      ["tile_8", "tile_5", "tile_20", "tile_19"],
      ["tile_4", "tile_5", "tile_10", "tile_13"],
      ["tile_4", "tile_5", "tile_13", "tile_14"],
      ["tile_7", "tile_5", "tile_10", "tile_8"],
      ["tile_7", "tile_5", "tile_13", "tile_14"],
      # Row 4
      ["tile_4", "tile_15", "tile_8", "tile_9"],
      ["tile_2", "tile_1", "tile_10", "tile_13"],
      ["tile_12", "tile_5", "tile_6", "tile_7"],
      ["tile_4", "tile_14", "tile_20", "tile_19"],
      ["tile_4", "tile_7", "tile_10", "tile_11"],
      ["tile_4", "tile_7", "tile_8", "tile_11"],
      ["tile_7", "tile_8", "tile_10", "tile_11"],
      ["tile_7", "tile_8", "tile_13", "tile_11"],
      # Row 5
      ["tile_14", "tile_15", "tile_8", "tile_9"],
      ["tile_1", "tile_2", "tile_7", "tile_8"],
      ["tile_12", "tile_13", "tile_6", "tile_7"],
      ["tile_14", "tile_13", "tile_19", "tile_20"],
      ["tile_4", "tile_7", "tile_10", "tile_13"],
      ["tile_4", "tile_8", "tile_13", "tile_14"],
      ["tile_7", "tile_8", "tile_10", "tile_14"],
      ["tile_7", "tile_8", "tile_13", "tile_14"]
    ]
  end

end
