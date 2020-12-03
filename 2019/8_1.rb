require_relative './aoc_helper'

class SpaceImage 
  def initialize(width:, height:, raw:)
    @width = width
    @height = height
    @raw = raw
  end

  def layers
    layer_size = @width * @height

    @raw.split('').map(&:to_i).each_slice(layer_size).to_a
  end

  def flattened_image
    all_layers = layers.clone
    image = all_layers.shift

    all_layers.each do |layer|
      layer.each_with_index do |pixel, i|
        if image[i] == 2
          image[i] = pixel
        end
      end
    end

    image
  end
end

image = SpaceImage.new(width: 25, height: 6, raw: inputs[0])

string = ""

image.flattened_image.each_slice(25) do |row| 
  row.each do |pixel|
    if pixel == 1
      string += '•'
    else
      string += ' '
    end
  end

  string += "\n"
end

puts string


