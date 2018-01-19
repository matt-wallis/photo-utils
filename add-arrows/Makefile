.PHONY: tests

.DEFAULT_GOAL:= tests

RUBY := ruby2.4
ADD_ARROWS := add-arrows.rb
OUTDIR := out

$(OUTDIR):
	mkdir -p $@

tests: | $(OUTDIR)
	$(RUBY) $(ADD_ARROWS) --input testdata/map1.jpg --output out/map1.jpg --points '100,100 32,123 222,127, 212,303'
	$(RUBY) $(ADD_ARROWS) --input testdata/tanyrallt.jpg --output out/tanyrallt.jpg --points '288,103 341,161 381,212 409,284 412,334 462,388 487,484 208,426 352,595 759,839'
	$(RUBY) $(ADD_ARROWS) --input testdata/llanafan.jpg --output out/llanafan.jpg --points '613,158 695,239 628,415 563,486 427,431 411,282'
	$(RUBY) $(ADD_ARROWS) --input testdata/Fronwen.jpg --output out/Fronwen.jpg --points '445,93'
