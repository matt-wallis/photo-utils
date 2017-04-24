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
	Geom::Vector.new(self, o).direction
      }.compact.sort
      complete_circle = angles_to_others << angles_to_others[0]
      openings = []
      complete_circle.each_cons(2) {|c| openings << Geom::Opening.new(c[0], c[1])}
      widest_opening = openings.max{|a, b| a.width <=> b.width}
      widest_opening.middle
    end
  end
  class Vector
    def initialize(p, q)
      @p, @q = p, q
    end
    def direction
      if (@p.y != @q.y)
	Math.atan((@p.x - @q.x)/(@p.y - @q.y))
      elsif (@p.x < @q.x)
	Math::PI/2
      elsif (@p.x > @q.x)
	-Math::PI/2
      else
	nil
      end
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

