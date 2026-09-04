#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf build/SuiShiMenuBar.app
mkdir -p build/SuiShiMenuBar.app/Contents/MacOS build/SuiShiMenuBar.app/Contents/Resources
swiftc mac-menubar/SuiShiMenuBar.swift -o build/SuiShiMenuBar.app/Contents/MacOS/SuiShiMenuBar -framework Cocoa -framework WebKit
cp mac-menubar/Info.plist build/SuiShiMenuBar.app/Contents/Info.plist
cp index.html styles.css calendar-polish.css app.js manifest.json icon-512-v4.png build/SuiShiMenuBar.app/Contents/Resources/
echo "Built build/SuiShiMenuBar.app"
