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

    debuild -i -us -uc -b
    debuild clean    
    
    sudo dpkg -i ../elementary-tweaks_0.2_amd64.deb
