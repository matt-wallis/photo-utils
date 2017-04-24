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
  def draw_arrow(label, to_point, from_direction)
    puts "Draw to #{to_point} from direction #{from_direction} radians, #{from_direction*180/Math::PI} degrees"
    rotation = from_direction*180.0/Math::PI
    arrow = Magick::Draw.new
    arrow.translate(to_point.x, to_point.y)
    arrow.pointsize(20)
    arrow.fill_opacity(0)
    arrow.stroke('red')
    arrow.stroke_opacity(0.7)
    arrow.stroke_width(2)
    arrow.stroke_linecap('round')
    arrow.stroke_linejoin('round')
    arrow.circle(0,0, 0,10)
    arrow.text_align(Magick::CenterAlign)
    text_dist = 25
    arrow.fill_opacity(0.5)
    arrow.fill('red')
    arrow.text(text_dist*Math::cos(from_direction), text_dist*Math::sin(from_direction) + 7, label)
    #arrow.rotate(rotation)
    #arrow.line(0, 0, 40, 0)
    arrow.draw(@img)
  end
end

$canvas = Canvas.new($options[:input_file])
#$points = $options[:points].map{|p| AddArrows::PointAmongOthers.new(p, $options[:points])}
$label = 1
$options[:points].each{|p|
  pp p.direction_of_widest_opening($options[:points])
  $canvas.draw_arrow($label.to_s, p, p.direction_of_widest_opening($options[:points]))
  $label += 1
}

$canvas.save($options[:output_file])

