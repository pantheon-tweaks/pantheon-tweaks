# elementary-tweaks
elementary-tweaks is a system settings component for elementary OS that lets you easily customise the desktop's appearance.

This repository is a fork of the [original elementary-tweaks](https://launchpad.net/elementary-tweaks) and could not have been done without the work of its [authors](AUTHORS) Michael P. Starkweather, Michael "Versable", PerfectCarl and additional [contributors](CONTRIBUTORS).

![sample](docs/screenshot.png)

## Development

* [Changelog](CHANGELOG.md)

### How to build
```
sudo apt-get install libgconf2-dev libpolkit-gobject-1-dev
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr ../
make 
    
sudo make install 
switchboard
```
