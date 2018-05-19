Gem::Specification.new do |s|
  s.name        = 'meta_tile_generator'
  s.version     = '0.0.0'
  s.date        = '2018-05-19'
  s.summary     = "MetaTileGenerator"
  s.description = "A tool to automate the creation of tilesets from metatiles"
  s.authors     = ["Tye Trask"]
  s.homepage    = 'https://github.com/tyetrask/meta_tile_generator'
  s.files       = [
    "lib/meta_tile_generator.rb"
  ]
  # s.homepage    = 'http://rubygems.org/gems/meta_tile_generator'
  s.license       = 'MIT'
  s.bindir = 'bin'
  s.executables << 'meta_tile_generator'
  s.add_runtime_dependency 'chunky_png', '~> 1.3'
end
