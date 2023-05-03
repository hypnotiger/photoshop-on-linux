#!/bin/bash

echo ""
echo "Starting Adobe Photoshop CC 2021 (v22) installer..."
echo ""
sleep 1

read -p "Give a name to the WINE Prefix that will be used. A folder with this name will be created in the current directory. " prefix_name
export WINEPREFIX="$PWD/$prefix_name"


if [ -d "$prefix_name" ]; then
  choice="0"
  read -p "A prefix by that name seems to be present, would you like to override that installation? (y/n): " choice
  if ! [ $choice = "y" ]; then
    echo ""
    echo "Aborting installation!"
    echo ""
    exit 1
  fi
  sleep 1
fi


echo "Checking for dependencies..."
sleep 0.5

if ! command -v curl &> /dev/null; then
  echo -e "- '${red}curl${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v wine &> /dev/null; then
  echo -e "- '${red}wine${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v tar &> /dev/null; then
  echo -e "- '${red}tar${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v wget &> /dev/null; then
  echo -e "- '${red}wget${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if [[ $MISSING == "1" ]]; then
  echo -e "\n${red}- ERROR:${reset} Please install the missing dependencies and then reattempt the installation"
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

sleep 1

echo "Booting & creating new prefix"
sleep 1
wineboot
sleep 1

echo "Setting win version to win10"
sleep 1
./scripts/winetricks win10
sleep 1

echo "Installing & configuring winetricks components..."
./scripts/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk vcrun2019 vcrun2012 vcrun2013 vcrun2010 vkd3d
sleep 1

echo "Installing redist components..."
sleep 1

wine installation_files/redist/2010/vcredist_x64.exe /q /norestart
wine installation_files/redist/2010/vcredist_x86.exe /q /norestart
wine installation_files/redist/2012/vcredist_x86.exe /install /quiet /norestart
wine installation_files/redist/2012/vcredist_x64.exe /install /quiet /norestart
wine installation_files/redist/2013/vcredist_x86.exe /install /quiet /norestart
wine installation_files/redist/2013/vcredist_x64.exe /install /quiet /norestart
wine installation_files/redist/2019/VC_redist.x64.exe /install /quiet /norestart
wine installation_files/redist/2019/VC_redist.x86.exe /install /quiet /norestart

sleep 1

echo "Copying launcher files and desktop icons..."

sleep 1
rm -f scripts/launcher.sh
rm -f scripts/photoshop.desktop

echo "#\!/bin/bash
cd \"$PWD/$prefix_name/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\"
WINEPREFIX=\"$PWD/$prefix_name\" wine photoshop.exe $1" > scripts/launcher.sh


echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c '$PWD/scripts/launcher.sh'
Type=Application
Comment=Photoshop CC 2021
Categories=Graphics;2DGraphics;RasterGraphics;Production;
Icon=$PWD/images/photoshop.svg
StartupWMClass=photoshop.exe
MimeType=image/png;image/psd;" > scripts/photoshop.desktop

chmod u+x scripts/launcher.sh
chmod u+x scripts/photoshop.desktop

rm -f ~/.local/share/applications/photoshop.desktop
mv scripts/photoshop.desktop ~/.local/share/applications/photoshop.desktop

sleep 1

echo "Adobe Photoshop CC 2021 (v22) Installation has been completed!"