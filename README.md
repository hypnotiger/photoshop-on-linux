# Winetricks configuration for Adobe Photoshop CC on Linux

![image](./images/screenshot.png)

# Description
This script sets up a WINE prefix that can be used to install and run some modern versions of Adobe Photoshop.  
It has been tested with CC 2022 (v23).  
**This script is heavily work in project, and the final Photoshop installation might not be ready for usage in production (see Known issues).**  
The installer doesn't download Adobe Photoshop or plugins for you. Once a prefix is prepared, you can use it to install Photoshop by yourself.

# READ THIS!
## Usability
Currently (July 2023) I wouldn't recommend this app to be used in serious production. Some features work with hiccups, and some (essentially everything powered by the GPU) just don't whatsoever, yet.
## Features that don't work and there's no known workarounds yet
*Only tested on Photoshop 2022, and only on my setup with an AMD GPU. If you know more about these problems or managed to solve them, please kindly let me know via creating an issue, and I will look into testing it more and adding it to the automated setup script. :)*
*It seems like all these issues can essentially be boiled down to "Vulkan GPU driver isn't being very friendly to this app, yet".*
- Once you have GPU set up, you'll end up turning it off in Photoshop Preferences, as it will prevent opening or creating new files (due to Vulkan not supporting `child window rendering` that Photoshop needs to render those new files)
- (On KDE Plasma) Does not respect panels, some elements of the interface could end up hidden behind a panel
- Marquee tool sometimes makes Photoshop freeze and then never un-freeze
- Dragging files from a file manager (tested with Dolphin) into Photoshop window might cause it to crash
- `Object Selection Tool`, `Select Object`, and other similar features can never find any objects on the image, and will always error-out
## Untested features
- Wayland (considering [wine-wayland](https://github.com/varmd/wine-wayland) or [this development branch of Wine by Alexandros Frantzis](https://gitlab.collabora.com/alf/wine/))
- Licensing
- Camera Raw
- Plugins
- Probably lots of others
## Projects status
I initially forked this for my own use and got it to the point where I can, more or less, use it for my side job at a printing house, while pressing Save shortcut every several minutes and being patient for when it crashes and such and such. I noticed that this project is getting a bit of attention on GitHub without me promoting it in any way, and I would also honestly love to just turn this into something *actually* usable, so I will definitely investigate more into making Photoshop behave better with Vulkan. However, due to various life circumstances I haven't had as much time to work on this as I initially planned to have. If you happened to decide to tinker with this repo, I would be very happy to hear any feedback, hints or advice, and overall about your experience with it (as I only have a single AMD iGPU to test on). Thanks for reading. :)

# Requirements
- An internet connection
- All **read** and **write** rights on your home folder and the folder of installation
- `git`
- `wine` >=8.0
- `tar`
- `wget`
- `curl`

## Optional
- Vulkan capable GPU or APU
- Latest graphics drivers for your GPU, including:
    - OpenGL
    - OpenCL

### Optional dependencies which need to be tested more
- `dxvk` - apparently drastically speeds up the Photoshop launch time if installed on the system
- `winetricks winbind`, `samba` - for [NTLM](https://en.wikipedia.org/wiki/NTLM)
- `lib32-gnutls` - might be required for licensing or adobe cloud

# Using the script

Open your terminal and:

```bash
# Clone the repo

git clone https://github.com/tigeritest/photoshop-on-linux.git
cd photoshop-22-linux

# Run the installation script:

./installer.sh

```
During the installation, several popups will appear to agree to several Microsoft packages' terms of use.
# Set up steps after using the script
Make note of the path to the prefix directory that you created with the script. WINEPREFIX= requires an **absolute path**, for example, `/home/user/photoshop/` instead of `~/photoshop`.
## For Photoshop 2022 (v23)
Use the original installer (.exe). Replace "/path/to/prefix" with created directory and "filename.exe" with the installer's name.
```bash
WINEPREFIX=/path/to/prefix wine "filename.exe"
```
For example:
```bash
WINEPREFIX=~/Photoshop wine "Adobe Photoshop 2022.exe"
```
# After Photoshop has been installed
## Starting Photoshop

After you run the installer, open your application menu, and search for "Photoshop", and click on it. As simple as that!

![image](https://github.com/tigeritest/photoshop-22-linux/blob/main/images/menu.png)


## Configure Photoshop:

Launch Photoshop and go to: `Edit -> preferences -> tools`, and uncheck "_Show Tooltips_" (You will not be able to use any plugins otherwise).


## CREDITS

+ [MiMillieuh](https://github.com/MiMillieuh) for finding the components that make Photoshop run using `wine`.
+ [YoungFellow-le](https://github.com/YoungFellow-le) for his work on the original version of this installer for Photoshop CC 2021 (v22)
