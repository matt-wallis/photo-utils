require 'photo_index'

options = PhotoIndex::Options.new(:index_in, :index_out).config
photolib = PhotoIndex::Index.new
photolib.load_from_xml(options.index_in)
photolib.collect_metadata
photolib.save_to_xml(options.index_out)



