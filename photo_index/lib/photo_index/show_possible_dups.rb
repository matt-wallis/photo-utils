require 'pp'
module PhotoIndex
  class Index
    def show_possible_dups
      ind = index_by_basename
      dirs_to_photos = Hash.new{|h, k| h[k] = [] }
      ind.values.find_all {|v| v.size > 1 }.each {|v| 
	dirs_to_photos[v.map{|p| File.dirname(p.filename)}].concat(v)
      }
      pp dirs_to_photos.keys
	
    end
    def index_by_basename
      res = Hash.new {|h,k| h[k] = []}
      @photos.values.each {|p|
	res[File.basename(p.filename)] << p
      }
      res
    end
  end
end

