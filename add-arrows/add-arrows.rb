require 'pp'
require 'optparse'
require 'rmagick'
require_relative 'geom'

$options = {}
$options[:arrow_fill_colour] = "red"
$options[:points] = []
$options[:input_file] = nil
$options[:output_file] = nil
$options[:errors] = []
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [$options]"

  opts.on("-i", "--input-file INPUT", "Name of image file to which arrows are to be added") do |f|
    $options[:input_file] = f
  end
  opts.on("-o", "--output-file OUTPUT", "Name of output file to which arrows have been added") do |f|
    $options[:output_file] = f
  end
  opts.on("-p", "--points POINTS", "Pixel co-ordinates where arrows are to point (e.g. --points '100,200 234,345')") do |ps|
    $options[:points] = ps.split.map{|c|
      begin
	coords_as_str = c.split(",")
	raise(ArgumentError, "Expected 2 coordinates, found: #{c}") unless coords_as_str.size == 2
	coords_as_f = coords_as_str.map{|y| Float(y)}	# Float() produces ArgumentError for non floaty args
	Geom::Point.new(coords_as_f[0], coords_as_f[1])
      rescue ArgumentError => e
	$options[:errors] << e
      end
    }
  end
  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    $options[:verbose] = v
  end
  opts.on("-h", "--help", "Help!") do
    puts opts
    exit
  end
end.parse!

p $options
p ARGV
if $options[:errors].size > 0
  $options[:errors].each {|e|
  $stderr.puts e
  }
  $stderr.puts "Exiting due to errors."
  exit 1
end

class Canvas
  def initialize(img)
    @img = Magick::ImageList.new(img)
  end
  def save(file)
    @img.write(file)
  end
end

#$points = $options[:points].map{|p| AddArrows::PointAmongOthers.new(p, $options[:points])}
$options[:points].each{|p|
  pp p.direction_of_widest_opening($options[:points])
}

$canvas = Canvas.new($options[:input_file])
$canvas.save($options[:output_file])

