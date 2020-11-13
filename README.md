# Pantheon Tweaks
A system settings panel for the Pantheon Desktop that lets you easily and safely customise your desktop's appearance.

Pantheon Tweaks is supported on elementary OS **Odin** and above. For users on elementary OS **Juno** or below, please instead use [elementary tweaks](https://github.com/elementary-tweaks/elementary-tweaks).

![sample](docs/screenshot.png)

## Installation
### From PPA (recommended)
If you have never added a PPA on your system before, you might need to run this command first: 

```
sudo apt install software-properties-common
```

Add the PPA of Pantheon Tweaks and then install it:

```
sudo add-apt-repository ppa:philip.scott/pantheon-tweaks
sudo apt install pantheon-tweaks
```

Open System Settings and there should be a new Plug named "Tweaks". 

**Note:** if you are currently on Odin daily builds, follow [this](https://github.com/pantheon-tweaks/pantheon-tweaks/issues/43#issuecomment-720077052) to install Pantheon Tweaks instead.

### From Source Code
If you want to install from source code, clone this repository and then run the following commands:

```
sudo apt install libswitchboard-2.0-dev elementary-sdk
meson build --prefix=/usr
cd build
ninja

sudo ninja install
io.elementary.switchboard
```

## Special Thanks
This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable" Langfermann, PerfectCarl, Marvin Beckers and additional [contributors](CONTRIBUTORS).
