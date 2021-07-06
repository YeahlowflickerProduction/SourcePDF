#!/bin/sh
clear
source ./venv/bin/activate
python3 -OO -m PyInstaller -F --clean --onefile SourcePDF.AppImage.spec -i=sourcepdf_icon.ico
