#!/bin/bash

nimble install --silent

desktop_file="[Desktop Entry]
Name=Dela
Exec=$HOME/.nimble/bin/Dela
Icon=$HOME/.local/share/applications/Dela.svg
Terminal=false
Type=Application"

cp ./Dela.svg ~/.local/share/applications/Dela.svg

echo "$desktop_file" > ~/.local/share/applications/dela.desktop
