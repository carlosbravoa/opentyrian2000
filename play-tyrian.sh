#!/bin/sh
# Launch OpenTyrian2000 with its music streaming to a RetroWave OPL3 Express.
#
# Usage:
#   ./play-tyrian.sh                # game on the board (default /dev/ttyACM0)
#   ./play-tyrian.sh ttyACM1        # game on a different serial device
#   ./play-tyrian.sh -              # game with no board (dry run / normal audio)
#
# Extra args are passed through, e.g.:  ./play-tyrian.sh ttyACM0 --no-xmas
#
# For a standalone music jukebox (no game), see the separate project:
#   https://github.com/carlosbravoa/tyrian-retrowave-player

set -e
cd "$(dirname "$0")"

DEV="${1:-ttyACM0}"
[ $# -gt 0 ] && shift || true

# Warn (don't fail) if the board isn't there, unless this is a dry run.
if [ "$DEV" != "-" ] && [ ! -e "/dev/$DEV" ]; then
	echo "warning: /dev/$DEV not found — is the RetroWave board plugged in?" >&2
fi

[ -x ./opentyrian2000 ] || make WITH_NETWORK=false
exec ./opentyrian2000 --retrowave="$DEV" "$@"
