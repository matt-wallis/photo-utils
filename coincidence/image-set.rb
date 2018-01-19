
class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean 
    sum / size
  end
end

module Coincidence
  class Image
    Separator = "\t"
    attr_reader :filename, :points
    def initialize(filename, points)
      @filename, @points = filename, points
      raise "Currently, and Image must have exactly 2 reference points. Found #{points.size}." unless points.size == 2
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
    def angle	# Between reference points
      Math.atan2(by - ay, bx - ax)
    end
    # Short-hand - 2 points, a and b with x and y co-ords
    def ax
      points[0][0]
    end
    def ay
      points[0][1]
    end
    def bx
      points[1][0]
    end
    def by
      points[1][1]
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

