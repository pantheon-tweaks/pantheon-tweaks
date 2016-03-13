## How to build

    sudo apt-get install libgconf2-dev libpolkit-gobject-1-dev
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/usr ../
    make 
    
    sudo make install 
    switchboard

## How to test 
    ll /tmp/theme-patcher-*

    sudo gedit /usr/share/themes/elementary/gtk-3.0/gtk-widgets-dark.css
    sudo gedit /usr/share/themes/elementary/gtk-3.0/gtk-widgets.css
    
    sudo cp /usr/share/themes/elementary/gtk-3.0/gtk-widgets.css /usr/share/themes/elementary/gtk-3.0/gtk-widgets.css.copy 
    sudo cp /usr/share/themes/elementary/gtk-3.0/gtk-widgets-dark.css /usr/share/themes/elementary/gtk-3.0/gtk-widgets-dark.css.copy

    
    sudo apt-get install elementary-theme --reinstall 
    sudo gedit /usr/share/themes/elementary/gtk-3.0/gtk-widgets.css

    sudo /usr/lib/x86_64-linux-gnu/switchboard/personal/tweaks/theme-patcher
    sudo /usr/lib/x86_64-linux-gnu/switchboard/personal/tweaks/theme-patcher true 16 5 "#2E3436"
    
## Packaging 

### 64bits -> 64bits 

    debuild -i -us -uc -b
    debuild clean    
    
    sudo dpkg -i ../elementary-tweaks_0.2_amd64.deb

### 64bits -> 32bits

Setting up the environment

### Setting up a chroot (about 700M to build a cmake vala gtk app)     
    # Install the cross compiling toolchain (about 50M on the disk)
    sudo apt-get install g++-multilib 
    # Then install the 32bits version of your dependencies in a sandboxed environment
Using [this tutorial](http://www.kaizou.org/2014/02/cross-compile-chroot/)
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:vala-team
    sudo apt-get install valac-0.26

### Installing the i836 deps locally
From this [SO answer](http://stackoverflow.com/a/23207868/740464)

    dpkg --add-architecture i386 
    apt-get update
    apt-get install libc6:i386 

Then error 
```
cran@cran-UX31E:~/Documents/Projects/elementary/elementary-tweaks/patching-egtk$ sudo apt-get install libgee-0.8-dev:i386
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help resolve the situation:

The following packages have unmet dependencies:
 libgee-0.8-dev:i386 : Depends: gir1.2-gee-0.8:i386 (= 0.16.1-1~14.04~valateam2) but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```
### Building the application
    debuild -ai386 -i -us -uc -b
    debuild clean    
