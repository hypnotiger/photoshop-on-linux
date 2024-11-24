#!/bin/bash

# Checking for dependencies
if ! command -v curl &> /dev/null; then
  echo -e "Error - curl is MISSING!"
  MISSING=1
fi

if ! command -v wine &> /dev/null; then
  echo -e "Error - wine is MISSING!"
  MISSING=1
fi

if ! command -v tar &> /dev/null; then
  echo -e "Error - tar is MISSING!"
  MISSING=1
fi

if ! command -v wget &> /dev/null; then
  echo -e "Error - wget is MISSING!"
  MISSING=1
fi

if [[ $MISSING == "1" ]]; then
  echo -e "Please install the missing dependencies through your package manager,
then run this script again."
  exit 1
fi
# ------------

rm -f "$PWD/log_installer"
touch "$PWD/log_installer"

read -p "Welcome to the interactive WINEPREFIX setup for Adobe Photoshop CC!
This script will prepare a WINEPREFIX for you to use with your desired
version of Adobe Photoshop CC.
If you encounter any issues, please let us know by creating an Issue
in the GitHub repository.
------------------
Press Enter to start."

prefix_name=""
while [[ $prefix_name == "" ]]; do
  read -p "
Give a name to the Wine prefix that will be used.
A folder with this name will be created in the current directory.
> " prefix_name
  echo ""
done

if [[ -d "$prefix_name" ]]; then
  choice="0"
  read -p "A directory by that name is already present:
  $PWD/$prefix_name
Would you like to override it? (y/N): " choice
  if [[ "$choice" == "y" ]]; then

  rm -rf "./$prefix_name"
  echo ""
  else
    echo ""
    echo "Aborting installation!"
    echo ""
    exit 1
  fi
fi


ps_version=""
echo "Please specify the year of Adobe Photoshop version that you intend
to use with this prefix, i.e. 2021, 2022, or another.
This script aims to support PS CC 2021-2024, but other versions might
work with it too. If you have any suggestions, please open an issue on
the GitHub repository."
while [[ $ps_version == "" ]]; do
  read -p "> " ps_version

  # Checking for value like 20XX (2022, 2023, etc...)
  if ! [[ $ps_version =~ ^'20'.. ]]; then
    ps_version=""
    echo "Please enter a year, for example: 2022"
  fi
done


export WINEPREFIX="$PWD/$prefix_name"

  echo "Making a new prefix for Adobe Photoshop..."
  rm -rf "$PWD/$prefix_name"
  mkdir "$PWD/$prefix_name"

  mkdir -p scripts

  if ! command -v winetricks &> /dev/null; then
    echo "Downloading winetricks..."
    wget -nc --directory-prefix=scripts/ https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
    chmod +x scripts/winetricks
  fi

  wineboot &>>./log_installer

  read -p "
Winetricks components will now be downloaded and installed.
Some installers will require you to click through them manually.
Checking Terms of Services checkboxes is necessary to continue.
Checking \"Send Microsoft usage data\" and other similar ones is not required.
Press Enter to begin installation."
  ./scripts/winetricks --force gdiplus msxml3 msxml6 atmlib corefonts dxvk vcrun2019 vcrun2012 vcrun2013 vcrun2010 vcrun2022 vkd3d 2>>./log_installer
  echo "Finished setting up winetricks"

  echo "Installing dxvk into the prefix. This is required for Photoshop to
recognize your GPU. For best results, ensure that all the required drivers
and mesa packages for your GPU are installed and up-to-date."
  WINEPREFIX=\"$PWD/$prefix_name\" ./scripts/winetricks dxvk &>>./log_installer
  WINEPREFIX=\"$PWD/$prefix_name\" setup_dxvk install &>>./log_installer
  echo "Finished setting up dxvk"

  ./scripts/winetricks win10 &>>./log_installer
  echo "Set Windows version to 10"

  rm -f scripts/launcher.sh
  rm -f scripts/photoshop.desktop

  echo "#\!/bin/bash
  cd \"$PWD/$prefix_name/drive_c/Program Files/Adobe/Adobe Photoshop $ps_version/\"
  WINEPREFIX=\"$PWD/$prefix_name\" wine photoshop.exe $1" > scripts/launcher.sh

  echo "[Desktop Entry]
  Name=Photoshop CC
  Exec=bash -c '$PWD/scripts/launcher.sh'
  Type=Application
  Comment=Photoshop CC $ps_version
  Categories=Graphics;2DGraphics;RasterGraphics;Production;
  Icon=$PWD/images/photoshop.svg
  StartupWMClass=photoshop.exe
  MimeType=image/png;image/psd;" > scripts/photoshop.desktop

  chmod u+x scripts/launcher.sh
  chmod u+x scripts/photoshop.desktop

  rm -f ~/.local/share/applications/photoshop.desktop
  mv scripts/photoshop.desktop ~/.local/share/applications/photoshop.desktop
  echo "Created a launch script and shortcut for Adobe Photoshop"

  echo ""

  echo "The WINEPREFIX for Adobe Photoshop CC $ps_version has been set up!
It's now time to install Photoshop by running the installer that you've
acquired somewhere else and specifying this WINEPREFIX. For example:

WINEPREFIX=$PWD/$prefix_name Photoshop_Set-Up.exe

If you already have Photoshop somewhere else on your system, it might
still be required to reinstall it manually into this prefix."
