⚠️ This is a work in progress! The API is not guaranteed at this time.

# MetaTileGenerator

MetaTileGenerator is a tool to help with the creation of meta tiles from standard tiles. Meta tiles are a technique when creating a videogame tileset that allows you to draw a small set of tiles (6) where two materials meet (such as grass and dirt). in a specific pattern. Those tiles can then be divided and turned into 48 configurations.

## What are meta tiles?

TODO

### How to use
(Note: Gem is not published yet)
```
gem install meta_tile_generator
```
or, in your `Gemfile`
```
gem 'meta_tile_generator`
```

From the command line:
```shell
meta_tile_generator path/to/image.png 16
meta_tile_generator path/to/image.png 16 0 16 # X, Y Starting Coordinates within larger image
```

Within a project:
```ruby
require 'meta_tile_generator'
tile_width = 32
image_filepath = "path/to/image.png"
@meta_tile_generator = MetaTileGenerator.new(tile_width)
@meta_tile_generator.create_tileset_from(image_filepath)
```
