# Adobe Photoshop CC 2022 installer for Linux

![image](https://github.com/YoungFellow-le/photoshop-22-linux/blob/main/images/screenshot.png)

## Disclaimer
This script sets up a WINE prefix for you to use when installing Photoshop. It doesn't download Adobe Photoshop or plugins for you; once a prefix is prepared, you can use it to install Adobe Photoshop by yourself.

## Requirements
- An internet connection
- All **read** and **write** rights on your home folder and the folder of installation
- `git`
- `wine` >=6.1 (Avoid 6.20 to 6.22)
- `tar`
- `wget`
- `curl`
- Vulkan capable GPU or APU


## Installation guide:

Open your terminal and:

```bash
# Clone the repo

git clone https://github.com/tigeritest/photoshop-22-linux.git
cd photoshop-22-linux

# Run the installation script:

./installer.sh

```
## How to run Photoshop:

After you run the installer, open your application menu, and search for "Photoshop", and click on it. As simple as that!

![image](https://github.com/YoungFellow-le/photoshop-22-linux/blob/main/images/menu.png)


## Configure Photoshop:

Launch Photoshop and go to: `Edit -> preferences -> tools`, and uncheck "_Show Tooltips_" (You will not be able to use any plugins otherwise).


>_**NOTE:** If you do not find the desktop entry, or if it doesn't work, then run the`launcher.sh` file. This command should launch Photoshop for you, or it will at least tell you what the error is. (This command is also printed at the end of the installation)_

## CREDITS

+ [MiMillieuh](https://github.com/MiMillieuh) for finding the components that make Photoshop run using `wine`.
+ [YoungFellow-le](https://github.com/YoungFellow-le) for his work on the original version of this installer for Photoshop CC 2021 (v22)