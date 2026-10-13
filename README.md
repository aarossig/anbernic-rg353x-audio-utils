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
- **Independent Volume Preservation:** Automatically saves and restores separate
  volume levels for speaker and headphones across jack insertion/removal events.
- **Hearing Protection:** Automatically limits restored headphone volume and
  scales headroom to prevent audio blasts and minimize analog noise floor.
- **PipeWire 180 Hz High-Pass Filter:** Custom PipeWire filter-chain provides a
  180 Hz biquad high-pass filter with digital attenuation for the internal
  speaker, eliminating mechanical popping on deep bass.
- **Full-Range Headphone Routing:** Automatically routes headphones directly to
  the unfiltered hardware ALSA sink for full-range audio fidelity.
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
- `build/anbernic-rg353x-audio-utils_1.1.0_all.deb`

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
