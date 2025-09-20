# Pantheon Tweaks
A system customization app for the Pantheon Desktop that lets you easily and safely customise your desktop's appearance.

![light screenshot](data/screenshot.png#gh-light-mode-only)

![dark screenshot](data/screenshot-dark.png#gh-dark-mode-only)

## Installation
### From Flathub (Recommended)
You can download and install Pantheon Tweaks from Flathub:

[![Get it on Flathub](https://flathub.org/api/badge?locale=en)](https://flathub.org/apps/io.github.pantheon_tweaks.pantheon-tweaks)

You can launch it from the app launcher after installation.

> [!TIP]
> Pantheon Tweaks (and its ancestor, elementary Tweaks) was a plug of System Setting and has been provided through PPA for a long time, but it's an independent Flatpak app since 2.0.0.

### From Source Code
If you would like to install Pantheon Tweaks from source code, clone this repository and then run the following commands:

```
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub org.flatpak.Builder
flatpak run org.flatpak.Builder builddir --user --install --force-clean --install-deps-from=flathub build-aux/io.github.pantheon_tweaks.pantheon-tweaks.yml
```

## Supported Versions
Pantheon Tweaks supports the following versions of elementary OS:

  elementary OS Version | Supported?      |
  --------------------- | --------------- |
  0.4 Loki              | ❌
  5 Juno                | ❌
  5.1 Hera              | ❌
  6 Odin                | ✅
  6.1 Jólnir            | ✅
  7.0 / 7.1 Horus       | ✅
  8 Circe               | ✅

For users on elementary OS Hera or below, please use [elementary Tweaks](https://github.com/elementary-tweaks/elementary-tweaks) instead.

Pantheon Tweaks should also work on other distirbutions using Pantheon, thanks to Flatpak.

## Special Thanks
This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable" Langfermann, PerfectCarl, Marvin Beckers and additional [contributors](CONTRIBUTORS).
