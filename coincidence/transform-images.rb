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
  opts.on("--image-set IMAGESET", "IMAGESET is the name of a file specifying images and their reference points") do |f|
    $options[:image_set] = f
    unless File.exist?(f)
      $errors << "Image set file #{f} does not exist"
    end
    image_set = Coincidence::ImageSet.new
    image_set.read_image_set_file($options[:image_set])
    pp image_set
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

