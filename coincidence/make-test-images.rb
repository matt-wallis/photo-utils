require 'optparse'
require 'rmagick'
require 'pp'
require_relative 'image-set'
include Magick

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
  opts.on("--image-set IMAGESET", "IMAGESET is the name of a file specifying images and their reference points. It will be created") do |f|
    $options[:image_set] = f
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



# Circles from which points are to be chosen at random:
Centres = [[0.1, 0.1], [0.6, 0.7]]
Radius = 0.3
N_images = 3
Foreground = 'green'
Background = 'tomato'

Prng = Random.new

image_set = Coincidence::ImageSet.new

(1..N_images).each {|i|
  width, height = 100, 100
  pts = Centres.map{|c| [(c[0]+Prng.rand*Radius)*width, (c[1]+Prng.rand*Radius)*height] }
  filename = "#{$options[:output_dir]}/img-#{i}.png"
  img = Image.new(width, height) {
    self.background_color = Background
  }
  line = Draw.new
  line.stroke(Foreground)
  line.polyline(*pts.flatten)
  line.polyline(5, 5, 5, width-5)
  line.polyline(5, 5, height-5, 5)
  line.draw(img)
  img.write(filename)
  image_set.add_image(filename, pts)
  #puts "#{filename} #{pts.map{|p| p.join(',')}.join(' ')}"
}
image_set.save($options[:image_set])

