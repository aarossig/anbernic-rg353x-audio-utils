# anbernic-rg353x-headphone-detect

Automatic headphone jack detection and audio switching daemon for Anbernic
**RG353** series handheld consoles (**RG353V**, **RG353VS**, **RG353M**,
**RG353P**) powered by the Rockchip RK3566 SoC and RK817 audio codec.

## The Problem

On devices using the Rockchip RK817 audio codec, audio output routing between
the internal speaker (`SPK`) and the 3.5mm headphone jack (`HP`) is controlled
via an internal ALSA multiplexer called `Playback Mux`.

On Linux distributions (such as Armbian or minimal Debian), the default saved
ALSA state restores `Playback Mux` to `HP` on boot, muting the internal
speaker even when no headphones are plugged in. Furthermore, the kernel driver
does not automatically switch the hardware multiplexer when headphones are
inserted or removed.

## The Solution

`headphone-jack-detect` is a hardened, event-driven Bash daemon running as a
lightweight systemd service:

- **Zero CPU Usage:** Sleeps inside the kernel `poll()` call via
  `alsactl monitor` (0.00% idle CPU).
- **Minimal Footprint:** Pure Bash requiring ~1 MB RAM with zero external
  runtimes (no Python, no heavy sound server dependencies).
- **Universal Compatibility:** Directly controls the hardware ALSA
  multiplexer. Audio switches seamlessly whether games and emulators
  (RetroArch, PPSSPP) talk directly to ALSA or through PipeWire and
  PulseAudio.
- **PipeWire / WirePlumber Out-of-the-Box:** Includes a WirePlumber session
  rule prioritizing internal RK817 audio over Rockchip HDMI output and diverts
  broken upstream `alsa-ucm-conf` profiles.
- **Robust:** Includes boot-time sound card readiness probing, mechanical
  contact debouncing, clean signal handling, and dynamic recovery if the
  audio subsystem restarts.

## Installation

Download the latest `.deb` package from the Releases page and install it with
`apt`:

```bash
sudo apt install ./anbernic-rg353x-headphone-detect_*.deb
```

The systemd service will be automatically enabled and started immediately.

## Building from Source

Build the Debian package from source:

```bash
git clone https://github.com/aarossig/anbernic-rg353x-headphone-detect.git
cd anbernic-rg353x-headphone-detect
make deb
```

The built package will be created in `build/`:
- `build/anbernic-rg353x-headphone-detect_1.0.0_all.deb`

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
