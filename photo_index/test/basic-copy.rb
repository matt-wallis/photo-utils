require 'test/unit'
require 'photo_index'

class BasicCopy < Test::Unit::TestCase
  def setup
    #puts "setup"
  end
  def teardown
    #puts "teardown"
  end
  def test1
    photolib = PhotoIndex::Index.new
    photolib.load_from_xml('basic-copy/input.xml')
    photolib.save_to_xml('basic-copy/output.xml')
  end
end
