require 'pp'
require 'optparse'

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
    begin
    $options[:points] = ps.split.map{|c| c.split(",").map{|y| Float(y)} }
    rescue ArgumentError => e
      # Integer() will produce ArgumentError for bad args
      $options[:errors] << e
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

p $options
p ARGV
if $options[:errors].size > 0
  $options[:errors].each {|e|
  $stderr.puts e
  }
  $stderr.puts "Exiting due to errors."
end

module AddArrows
  def self.angle(p, q)
    return nil if p == q
    return Math.atan((p[0] - q[0])/(p[1] = q[1]))
    #return Math.atan((p[0] - q[0])/(p[1] = q[1]))*180/Math::PI
  end
  class PointAmongOthers
    def initialize(point, others)
      @point = point
      @others = others	# other points
    end
    def direction_of_widest_opening
      angles_to_others = @others.map{|o| AddArrows::angle(@point, o)}.compact.sort
      complete_circle = angles_to_others << angles_to_others[0]
      openings = []
      complete_circle.each_cons(2) {|c| openings << AddArrows::Opening.new(c[0], c[1])}
      widest_opening = openings.max{|a, b| a.width <=> b.width}
      widest_opening.middle
    end
  end
  class Opening
    def initialize(a, b)	# a, b angles at either end of the opening
      @a, @b = a, b
    end
    def width
      (@a - @b).abs
    end
    def middle
      (@a + @b)/2
    end
  end
end

$points = $options[:points].map{|p| AddArrows::PointAmongOthers.new(p, $options[:points])}
$points.each{|p|
  pp p.direction_of_widest_opening
}

