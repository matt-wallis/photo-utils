require 'optparse'
require 'rmagick'
require 'pp'
require_relative 'image-set'
#include Magick

$options = {
  output_dir: nil,
  image_set: nil,
  verbose: false
}
$errors = []
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [$options]"

  opts.on("-o", "--output-directory OUTPUT", "Name of output directory. Test images will be written here") do |f|
    $options[:output_dir] = f
    unless File.directory?(f)
      $errors << "Directory #{f} does not exist"
    end
  end
  opts.on("--image-set IMAGESET", "IMAGESET is the name of a file specifying images and their reference points") do |f|
    $options[:image_set] = f
    unless File.exist?(f)
      $errors << "Image set file #{f} does not exist"
    end
  end
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    $options[:verbose] = v
  end
  opts.on("-h", "--help", "Help!") do
    puts opts
    exit
  end
end.parse!

$errors << "Must specify --output-directory" unless $options[:output_dir]
$errors << "Must specify --image-set" unless $options[:image_set]

if $errors.size > 0
  $errors.each {|e|
    $stderr.puts e
  }
  $stderr.puts "Exiting due to errors."
  exit 1
end

image_set = Coincidence::ImageSet.new
image_set.read_image_set_file($options[:image_set])
pp image_set

mean_angle = image_set.map {|i| i.angle}.mean
puts "Mean angle: #{mean_angle}"
def rad_to_deg(r)
  r * 180 / Math::PI
end

min_dist = image_set.map {|i| i.dist}.min

# Use first image to define reference point 'destinations'
dest_points = image_set.first.points
ref_image = Magick::ImageList.new(image_set.first.filename)
viewport = "#{ref_image.columns}x#{ref_image.rows}+0+0"
puts viewport

image_set.each {|i|
  img = Magick::ImageList.new(i.filename)
  img.background_color = 'blue'
  filename = "#{$options[:output_dir]}/#{File.basename(i.filename)}"
  img_rotated = img.rotate(rad_to_deg(mean_angle - i.angle))
  img_rotated.write(filename)

  aff_filename = "#{$options[:output_dir]}/aff_#{File.basename(i.filename)}"
  scaling = min_dist/i.dist 
  rotation = mean_angle - i.angle
  tx = -i.ax
  ty = -i.ay
  matrix = Magick::AffineMatrix.new(scaling, rotation, rotation, scaling, tx, tx)
  img_affined = img.affine_transform(matrix)
  img_affined.write(aff_filename)

  img_distorted = img.distort(Magick::AffineDistortion, i.points.zip(dest_points).flatten) {
    self.define "distort:viewport", viewport
  }
  distort_filename = "#{$options[:output_dir]}/distort_#{File.basename(i.filename)}"
  img_distorted.write(distort_filename)
}

