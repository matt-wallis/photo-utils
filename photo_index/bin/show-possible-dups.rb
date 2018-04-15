require 'photo_index'

options = PhotoIndex::Options.new(:index_in).config
photolib = PhotoIndex::Index.new
photolib.load_from_xml(options.index_in)
photolib.show_possible_dups
