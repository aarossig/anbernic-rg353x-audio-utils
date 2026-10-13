# anbernic-rg353x-audio-utils

Audio support utilities and automatic headphone jack detection for Anbernic
**RG353** series handheld consoles (**RG353V**, **RG353VS**, **RG353M**,
**RG353P**) powered by the Rockchip RK3566 SoC and RK817 audio codec.

## Overview

The Rockchip RK817 audio codec routes output between the internal speaker
(`SPK`) and the 3.5mm headphone jack (`HP`) using an ALSA multiplexer called
`Playback Mux`.

On Linux distributions (such as Armbian or minimal Debian), default ALSA states
often mute the internal speaker on boot. The kernel driver does not switch the
multiplexer when headphones are inserted or removed. Additionally, unfiltered
low-frequency audio causes mechanical popping on the internal 20mm speaker, and
unregulated headphone volume causes deafening levels on connection.

`anbernic-rg353x-audio-utils` provides a comprehensive solution:

- **Jack Detection Daemon (`headphone-jack-detect`):** Hardened, event-driven
  Bash daemon running as a systemd service. Sleeps inside `poll()` via
  `alsactl monitor` with 0.00% idle CPU usage.
- **Pop-Free Mute Transitions:** Two-stage muting sequence silences hardware DAC
  and software sinks during transitions, eliminating pops and loud bursts.
- **Calibrated Gain Staging:** Calibrates hardware Master registers (reg 215 for
  speaker, reg 240 for headphones) for optimal signal-to-noise ratio.
- **PipeWire 280 Hz High-Pass Filter:** Custom PipeWire filter-chain provides a
  280 Hz 4th-order Linkwitz-Riley high-pass filter (24 dB/octave) for the internal
  speaker, eliminating mechanical cone bottoming and maximizing volume clarity.
- **Full-Range Virtual Headphones Sink:** Dedicated virtual Headphones sink
  (`sink.anbernic-headphones`) provides clean, unattenuated full-range audio.
- **ALSA UCM Diversion:** Automatically diverts conflicting upstream
  `alsa-ucm-conf` profiles.

## Installation

Download the latest `.deb` package from the Releases page and install it with `apt`:

```bash
sudo apt install ./anbernic-rg353x-audio-utils_*.deb
```

The systemd service will be enabled and started automatically.

## Building from Source

Build the Debian package using `make` or `dpkg-buildpackage`:

```bash
git clone https://github.com/aarossig/anbernic-rg353x-audio-utils.git
cd anbernic-rg353x-audio-utils
make deb
```

Or build with standard Debian tooling:

```bash
dpkg-buildpackage -us -uc -b
```

The built package is placed in `build/`:
- `build/anbernic-rg353x-audio-utils_1.1.1_all.deb`

## Status & Diagnostics

Check the status of the service:

```bash
systemctl status headphone-jack-detect.service
```

Follow live logs when plugging and unplugging headphones:

```bash
journalctl -u headphone-jack-detect.service -f
```

## License

GNU General Public License v2.0 or later ([GPL-2.0-or-later](LICENSE)).
