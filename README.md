# Winetricks configuration for Adobe Photoshop CC on Linux

![image](https://github.com/tigeritest/photoshop-22-linux/blob/main/images/screenshot.png)

# Description
This script sets up a WINE prefix that can be used to install and run some modern versions of Adobe Photoshop.  
It has been tested with CC 2022 (v23).  
Some issues still persist - this script is heavily **work in progress**!  
The installer doesn't download Adobe Photoshop or plugins for you. Once a prefix is prepared, you can use it to install Photoshop by yourself.

# Requirements
- An internet connection
- All **read** and **write** rights on your home folder and the folder of installation
- `git`
- `wine` >=8.0
- `tar`
- `wget`
- `curl`
- Vulkan capable GPU or APU

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
WINEPREFIX=/path/to/prefix wine 'filename.exe'
```
# After Photoshop has been installed
## Starting Photoshop

After you run the installer, open your application menu, and search for "Photoshop", and click on it. As simple as that!

![image](https://github.com/tigeritest/photoshop-22-linux/blob/main/images/menu.png)


## Configure Photoshop:

Launch Photoshop and go to: `Edit -> preferences -> tools`, and uncheck "_Show Tooltips_" (You will not be able to use any plugins otherwise).


>_**NOTE:** If you do not find the desktop entry, or if it doesn't work, then run the`launcher.sh` file. This command should launch Photoshop for you, or it will at least tell you what the error is. (This command is also printed at the end of the installation)_

## CREDITS

+ [MiMillieuh](https://github.com/MiMillieuh) for finding the components that make Photoshop run using `wine`.
+ [YoungFellow-le](https://github.com/YoungFellow-le) for his work on the original version of this installer for Photoshop CC 2021 (v22)