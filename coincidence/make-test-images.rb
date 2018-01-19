require 'optparse'
require 'rmagick'
require 'pp'
include Magick

$options = {
  output_dir: nil,
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
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    $options[:verbose] = v
  end
  opts.on("-h", "--help", "Help!") do
    puts opts
    exit
  end
end.parse!

$errors << "Must specify --output-directory" unless $options[:output_dir]

if $errors.size > 0
  $errors.each {|e|
    $stderr.puts e
  }
  $stderr.puts "Exiting due to errors."
  exit 1
end



# Circles from which points are to be chosen at random:
Centres = [[0.2, 0.2], [0.6, 0.7]]
Radius = 0.2
N_images = 3
Foreground = 'green'
Background = 'tomato'

Prng = Random.new

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
  line.draw(img)
  img.write(filename)
  puts "#{filename} #{pts.map{|p| p.join(',')}.join(' ')}"
}
