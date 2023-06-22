# Winetricks configuration for Adobe Photoshop CC on Linux

![image](https://github.com/tigeritest/photoshop-22-linux/blob/main/images/screenshot.png)

# Description
This script sets up a WINE prefix that can be used to install and run some modern versions of Adobe Photoshop.  
It has been tested with CC 2022 (v23).  
**This script is heavily work in project, and the final Photoshop installation might not be ready for usage in production (see Known issues).**  
The installer doesn't download Adobe Photoshop or plugins for you. Once a prefix is prepared, you can use it to install Photoshop by yourself.

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
    - vkd3d-proton (DirectX 12 implementation)
- `dxvk` - apparently drastically speeds up the Photoshop launch time (needs to be tested more)
- `winbind` (Wine terminal output will complain about this but what is it for is not known)

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