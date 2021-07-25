# Pantheon Tweaks
A system settings panel for the Pantheon Desktop that lets you easily and safely customise your desktop's appearance.

Pantheon Tweaks is currently only supported on elementary OS **Odin**. For users on elementary OS **Hera** or below, please instead use [elementary Tweaks](https://github.com/elementary-tweaks/elementary-tweaks).

![sample](docs/screenshot.png)

## Installation
### From PPA (recommended)
If you have never added a PPA on your system before, you might need to run this command first:

```
sudo apt install -y software-properties-common
```

Add the PPA of Pantheon Tweaks and then install it:

```
sudo add-apt-repository -y ppa:philip.scott/pantheon-tweaks
sudo apt install -y pantheon-tweaks
```

Open System Settings and there should be a new Plug named "Tweaks".

### From Source Code
If you want to install from source code, clone this repository and then run the following commands:

```
sudo apt install -y elementary-sdk
meson build --prefix=/usr
cd build
ninja

sudo ninja install
io.elementary.switchboard
```

## Special Thanks
This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable" Langfermann, PerfectCarl, Marvin Beckers and additional [contributors](CONTRIBUTORS).
