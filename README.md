# Pantheon Tweaks
A system settings panel for the Pantheon Desktop that lets you easily and safely customise your desktop's appearance.

Pantheon Tweaks is currently only supported on elementary OS **Odin**. For users on elementary OS **Juno** or below, please instead use [elementary Tweaks](https://github.com/elementary-tweaks/elementary-tweaks).

![sample](docs/screenshot.png)

## Installation
### From PPA (recommended)
If you have never added a PPA on your system before, you might need to run this command first:

```
sudo apt install software-properties-common
```

Add the PPA of Pantheon Tweaks and then install it:

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv c42d52715a84c7d0d02fc740c1d89326b1c71ab9
echo -e "deb http://ppa.launchpad.net/philip.scott/pantheon-tweaks/ubuntu focal main\ndeb-src http://ppa.launchpad.net/philip.scott/pantheon-tweaks/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/pantheon-tweaks.list
sudo apt update
sudo apt install pantheon-tweaks
```

Open System Settings and there should be a new Plug named "Tweaks".

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
