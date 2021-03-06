ARCH=$(shell uname -m | sed -e s/i.86/i386/)
CFLAGS=-Wall -g -O2 -fPIE -pie
LDLIBS=-ldl
SAMPLES=3333

ifeq ($(ARCH),i386)
	CFLAGS+=-m32
endif

bins=libcaddr textaddr

all: $(bins:%=%.png)

$(bins:%=%.data): %.data: %
	./gensome $* $(SAMPLES) > $*.data

$(bins:%=%.png): %.png: %.data
	./analyze.pl --out $*.stats --gnuplot $*.gpl $*.data
	gnuplot $*.gpl
	@echo $@ done

clean:
	rm -f $(bins:%=%.png) $(bins:%=%.data) $(bins:%=%.stats) $(bins)

.PHONY: clean
