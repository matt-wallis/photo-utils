
module Coincidence
  class Image
    Separator = "\t"
    attr_reader :filename, :points
    def initialize(filename, points)
      @filename, @points = filename, points
    end
    def to_s
      "#{filename}#{Separator}#{points.map{|p| p.join(',')}.join(Separator)}"
    end
    def self.from_s(s)
      tokens = s.split(Separator)
      filename = tokens.shift
      points = tokens.map {|t| t.split(',').map {|n| n.to_i}} 
      new(filename, points)
    end
  end
  class ImageSet < Array
    def initialize
    end
    def to_s
      map{|i| i.to_s}.join("\n")
    end
    def add_image(filename, points)
      self << Image.new(filename, points)
    end
    def save(image_set_filename)
      File.open(image_set_filename, "w") {|f|
	each {|i|
	  f.puts i
	}
      }
    end
    def read_image_set_file(image_set_filename)
      #puts image_set_filename
      File.open(image_set_filename, "r") {|f|
	f.each_line {|line|
	  self << Image.from_s(line)
	}
      }
    end
  end
end

