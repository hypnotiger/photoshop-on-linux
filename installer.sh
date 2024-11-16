#!/bin/bash

echo "Welcome to setup script for Adobe Photoshop CC!"

prefix_name=""
while [[ $prefix_name == "" ]]; do
  read -p "
Give a name to the Wine prefix that will be used.
A folder with this name will be created in the current directory.
> " prefix_name
  echo ""
done

ps_version=""
echo "Please specify the year of Adobe Photoshop version you'd like to set up now.
(For example, 2024)
This script is intended to be used with PS 2021-2024, but other versions might
work with it too. If you have any suggestions or corrections for your version,
please open an issue on the GitHub repository."
while [[ $ps_version == "" ]]; do
  read -p "> " ps_version

  # Checking for value like 20XX (2022, 2023, etc...)
  if ! [[ $ps_version =~ ^'20'.. ]]; then
    ps_version=""
    echo "Please enter a year, for example: 2022"
  fi
done

if [[ -d "$prefix_name" ]]; then
  choice="0"
  read -p "A prefix by that name seems to be present, would you like to override that installation? (y/N): " choice
  if [[ "$choice" == "y" ]]; then

  rm -rf ./$prefix_name

  else
    echo ""
    echo "Aborting installation!"
    echo ""
    exit 1
  fi
fi

export WINEPREFIX="$PWD/$prefix_name"

  echo "Checking for dependencies..."

  if ! command -v curl &> /dev/null; then
    echo -e "- '${red}curl${reset}' is MISSING!"
    MISSING=1
  fi

  if ! command -v wine &> /dev/null; then
    echo -e "- '${red}wine${reset}' is MISSING!"
    MISSING=1
  fi

  if ! command -v tar &> /dev/null; then
    echo -e "- '${red}tar${reset}' is MISSING!"
    MISSING=1
  fi

  if ! command -v wget &> /dev/null; then
    echo -e "- '${red}wget${reset}' is MISSING!"
    MISSING=1
  fi

  if [[ $MISSING == "1" ]]; then
    echo -e "\n${red}- ERROR:${reset} Please install the missing dependencies and then reattempt the installation!"
    exit 1
  fi

  echo "Making a new prefix for Adobe Photoshop..."
  sleep 1
  rm -rf $PWD/$prefix_name
  mkdir $PWD/$prefix_name
  sleep 1

  mkdir -p scripts

  echo "Downloading winetricks..."
  sleep 1
  wget -nc --directory-prefix=scripts/ https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x scripts/winetricks

  echo "Booting & creating new prefix"
  wineboot

  echo "Installing & configuring winetricks components..."
  ./scripts/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk vcrun2012 vcrun2013 vcrun2010 vcrun2022 vkd3d

  echo "Looking for dxvk..."
  if [ -d "/usr/share/dxvk" ]; then
    echo "Setting up dxvk..."
    WINEPREFIX=\"$PWD/$prefix_name\" setup_dxvk install
  else
    echo "dxvk not found - skipping"
  fi

  echo "Setting win version to win10"
  ./scripts/winetricks win10

  sleep 1
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

  sleep 1

  echo "The WINEPREFIX for Adobe Photoshop CC $ps_version has been set up!"
