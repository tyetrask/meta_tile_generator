#!/usr/bin/env ruby

require 'chunky_png'
require 'pry'

arguments = ARGV
input_filepath = arguments[0]
OUTPUT_FILEPATH = File.dirname(input_filepath)
output_filename = "#{File.basename(input_filepath, ".*")}_super#{File.extname(input_filepath)}"
should_crop = false
if arguments.length > 1
  should_crop = true
  x_start = arguments[1].to_i
  y_start = arguments[2].to_i
end

def save_image(image, filename, filepath=OUTPUT_FILEPATH)
  image.to_datastream.save(File.join(filepath, filename))
end

TILE_WIDTH = 16
TILE_HEIGHT = 16
METATILE_WIDTH = TILE_WIDTH / 2
METATILE_HEIGHT = TILE_HEIGHT / 2
BASE_WIDTH = TILE_WIDTH * 3
BASE_HEIGHT = TILE_HEIGHT * 2
SUPER_WIDTH = TILE_WIDTH * 8
SUPER_HEIGHT = TILE_HEIGHT * 8

original = ChunkyPNG::Image.from_file(input_filepath)
if should_crop
  original.crop!(x_start, y_start, BASE_WIDTH, BASE_HEIGHT)
end

metatile_x_y_positions = [
  [0, 0],  [8, 0],  [16, 0],  [24, 0],  [32, 0],  [40, 0],
  [0, 8],  [8, 8],  [16, 8],  [24, 8],  [32, 8],  [40, 8],
  [0, 16], [8, 16], [16, 16], [24, 16], [32, 16], [40, 16],
  [0, 24], [8, 24], [16, 24], [24, 24], [32, 24], [40, 24]
]

@metatile_collection = {}
metatile_x_y_positions.each do |x_y_position|
  x, y = x_y_position
  tile = original.crop(x, y, METATILE_WIDTH, METATILE_HEIGHT)
  @metatile_collection["tile_#{x}_#{y}"] = tile
end

tile_combinations = [
  # Row 0
  ["tile_32_16", "tile_40_16", "tile_32_24", "tile_40_24"],
  ["tile_0_0", "tile_24_0", "tile_0_24", "tile_24_24"],
  ["tile_0_8", "tile_24_8", "tile_0_16", "tile_24_16"],
  ["tile_8_0", "tile_16_0", "tile_8_24", "tile_16_24"],
  ["tile_0_0", "tile_8_0", "tile_0_8", "tile_40_8"],
  ["tile_0_16", "tile_40_0", "tile_0_24", "tile_8_24"],
  ["tile_32_0", "tile_24_8", "tile_16_24", "tile_24_24"],
  ["tile_8_0", "tile_24_0", "tile_32_8", "tile_24_16"],
  # Row 1
]

output_image = ChunkyPNG::Image.new(SUPER_WIDTH, SUPER_HEIGHT)

cursor = [0, 0]
tile_combinations.each_with_index do |metatiles, index|
  tile = ChunkyPNG::Image.new(TILE_WIDTH, TILE_HEIGHT)
  tile.compose!(@metatile_collection[metatiles[0]], 0, 0)
  tile.compose!(@metatile_collection[metatiles[1]], 8, 0)
  tile.compose!(@metatile_collection[metatiles[2]], 0, 8)
  tile.compose!(@metatile_collection[metatiles[3]], 8, 8)
  output_image.compose!(tile, cursor[0], cursor[1])
  cursor[0] += TILE_WIDTH
  if cursor[0] >= SUPER_WIDTH
    cursor[0] = 0
    cursor[1] += TILE_HEIGHT
  end
end

save_image(output_image, output_filename)
