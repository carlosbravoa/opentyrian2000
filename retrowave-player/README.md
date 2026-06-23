# Tyrian → RetroWave OPL3 Express

Two ways to hear Tyrian's music on a real Yamaha YMF262 (OPL3) via a
[RetroWave OPL3 Express](https://github.com/SudoMaker/RetroWave) board over
USB-serial (default `/dev/ttyACM0`, 2,000,000 baud).

Both paths run OpenTyrian's **actual** LDS music driver (`src/lds_play.c`) — the
same code the game uses — and simply forward the OPL register writes it produces
to the board instead of (or alongside) the software emulator. Output is
reference-grade: exact instruments, timing, and loop points.

## 1. Standalone player (this directory)

```
make
./tyrian_rwplay -d ttyACM0 /path/to/MUSIC.MUS
```

Options:

- `-d DEV`   serial device (default `ttyACM0`; `-` = dry run, no hardware)
- `-s N`     start at song N (1-based)
- `-l`       loop the current song instead of advancing
- `-h`       help

Transport keys while playing: `n`/space next, `p` prev, `r` restart, `l` toggle
loop, `+`/`-` tempo, `q` quit.

`MUSIC.MUS` is your own from a legitimate copy of Tyrian — it is **not**
redistributable and is not included here.

## 2. In-game integration

The game itself can stream its live music to the board:

```
./opentyrian2000 --retrowave=ttyACM0
```

The emulator still runs (it clocks the LDS sequencer from the audio sample
counter), but its PC music output is muted while the real chip plays. Sound
effects continue to play on the PC. Use `--retrowave=-` for a dry run.

## How it works

`src/retrowave_serial.c` is the shared serial backend: it implements the
RetroWave 7-of-8 wire framing and the OPL register-write / reset packets. The
standalone player provides a tiny shim so `lds_play.c`'s `opl_write()` calls land
in `retrowave_write()`; the in-game path hooks the same call inside
`adlib_write()` in `src/opl.c`.

The OPL chip has no timing of its own, so the standalone player drives
`lds_update()` at 69.5 Hz against absolute monotonic deadlines (the rate the game
uses). 2 Mbaud is mandatory — a wrong baud rate fails silently.
