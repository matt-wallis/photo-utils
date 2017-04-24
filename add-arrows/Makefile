.PHONY: tests

.DEFAULT_GOAL:= tests

RUBY := ruby2.3
ADD_ARROWS := add-arrows.rb
OUTDIR := out

$(OUTDIR):
	mkdir -p $@

tests: | $(OUTDIR)
	$(RUBY) $(ADD_ARROWS) --input testdata/map1.jpg --output out/map1.jpg --points '100,100 32,123 222,127, 212,303'
	#$(RUBY) $(ADD_ARROWS) --input testdata/map1.jpg --output out/map1.jpg --points '100,100 100,200 99,200 101,200'
