require 'pp'
require 'optparse'

$options = {}
$options[:include] = []
$options[:file_ext] = ["jpg"]
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [$options]"

  opts.on("-I", "--include DIRECTORY", "Directory to be scanned (including sub-directories)") do |d|
    $options[:include] << d
  end
  opts.on("-m", "--[no-]match-basename", "Match basename of file") do |m|
    $options[:match_basename] = m
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


class PhotoFile
  @@all = []
  # Map the names of instance methods on to the options symbols for selecting the use of this instance method for
  # finding matches:
  @@method_map = {basename: :match_basename}
  @@key_methods = @@method_map.keys.select{|k| $options[@@method_map[k]]}
  @@basename_to_photofile = Hash.new{|h, k| h[k] = []}
  def self.all
    @@all
  end
  def self.verbose
    $options[:verbose]
  end
  def self.find_all
    find_crit = $options[:file_ext].map{|e| "-iname '*.#{e}'"}.join(" -o ")
    $options[:include].each {|d|
      find_cmd = "find #{d} #{find_crit}"
      puts find_cmd if verbose
      `#{find_cmd}`.split(/\n+/).each {|f| PhotoFile.new(f)}
    }
  end
  def self.match_map
    @@match_map ||= Hash[@@all.map{|p| [p.match_key, p]}]
  end
  def match_key
    @@key_methods.map{|m| self.method(m).call}
  end
  def self.basename_to_photofile
    if @@basename_to_photofile.empty?
      all.each{|p| @@basename_to_photofile[p.basename] << p}
    end
    @@basename_to_photofile
  end
  def self.dup_basename_info
    basename_to_photofile.reject{|k,v| v.size == 1}
  end
  attr_reader :name
  def initialize(name)
    @name = name
    @@all << self
  end
  def basename
    File.basename(name, File.extname(name))
  end
  def directory
    File.directory(name)
  end
  def stat
    @stat ||= File::Stat.new(name)
  end
  private
end
PhotoFile.find_all

PhotoFile.all.each {|p|
  puts "#{p.name} #{p.stat.size}"
}
pp PhotoFile.match_map
#pp PhotoFile.dup_basename_info
