# Standalone Tyrian -> RetroWave OPL3 Express music player.
#
# Reuses the game's real LDS driver (../src/lds_play.c) and the shared serial
# backend (../src/retrowave_serial.c).  SDL2 is needed only for its headers
# (Uint*/endian types that lds_play.c uses); no SDL runtime is initialised.

SDL_CFLAGS := $(shell sdl2-config --cflags 2>/dev/null || pkg-config sdl2 --cflags)

CC      ?= gcc
CFLAGS  ?= -O2 -Wall -Wextra
CFLAGS  += -std=gnu11 -I../src $(SDL_CFLAGS)
LDLIBS  += -lSDL2

TARGET  := tyrian_rwplay
OBJS    := tyrian_rwplay.o lds_play.o retrowave_serial.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDLIBS)

tyrian_rwplay.o: tyrian_rwplay.c
	$(CC) $(CFLAGS) -c -o $@ $<

lds_play.o: ../src/lds_play.c
	$(CC) $(CFLAGS) -c -o $@ $<

retrowave_serial.o: ../src/retrowave_serial.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(TARGET) $(OBJS)

.PHONY: all clean
