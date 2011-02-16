CFLAGS=-Wall -g -O2 -fpie -pie -m32
LDLIBS=-ldl
SAMPLES=1234

bins=libcaddr mainaddr

all: $(bins:%=%.png)

$(bins:%=%.data): %.data: %
	./gensome $* $(SAMPLES) > $*.data

$(bins:%=%.png): %.png: %.data plot.gpl
	./plot $*

clean:
	rm -f $(bins:%=%.png) $(bins:%=%.data) $(bins:%=%.stats) $(bins)

.PHONY: clean
