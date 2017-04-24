module Geom
  class Point
    attr_reader :x, :y
    def initialize(x, y)
      @x, @y = x, y
    end
    def to_s
      "(#{x}, #{y})"
    end
    def direction_of_widest_opening(others)
      angles_to_others = others.map{|o| 
	angle = Geom::Vector.new(self, o).direction
	puts "Angle from #{self} to #{o} is #{angle} radians, #{angle*180/Math::PI} degrees" unless angle.nil?
	angle
      }.compact.sort
      complete_circle = angles_to_others << angles_to_others[0] + 2*Math::PI
      openings = []
      complete_circle.each_cons(2) {|c| openings << Geom::Opening.new(c[0], c[1])}
      puts openings
      widest_opening = openings.max{|a, b| a.width <=> b.width}
      puts "Widest opening from #{self} is #{widest_opening}"
      widest_opening.middle
    end
  end
  class Vector
    def initialize(p, q)
      @p, @q = p, q
    end
    def direction
      dx = @q.x - @p.x
      dy = @q.y - @p.y
      return nil if dx == 0 and dy == 0
      a = (dx == 0) ? (dy/dy.abs)*Math::PI/2 : Math::atan(dy/dx)
      if dx < 0
	a += Math::PI
      end
      if a < 0.0
	a += 2*Math::PI
      end
      raise "Angle out of range: #{a}" unless a >= 0.0 and 2*Math::PI
      return a
      #if (@p.x != @q.x)
	#Math.atan((@q.y - @p.y)/(@q.x - @p.x))
      #elsif (@p.y < @q.y)
	#Math::PI/2
      #elsif (@p.y > @q.y)
	#-Math::PI/2
      #else
	#nil
      #end
    end
  end
  class Opening
    def initialize(a, b)	# a, b angles at either end of the opening
      @a, @b = a, b
    end
    def to_s
      "between #{@a} and #{@b}, width: #{width}, middle: #{middle}"
    end
    def width
      (@b - @a).abs
    end
    def middle
      (@a + @b)/2
    end
  end
end

