#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf build/岁时.app
mkdir -p build/岁时.app/Contents/MacOS build/岁时.app/Contents/Resources
swiftc mac-menubar/SuiShiMenuBar.swift -o build/岁时.app/Contents/MacOS/岁时 -framework Cocoa -framework WebKit
cp mac-menubar/Info.plist build/岁时.app/Contents/Info.plist
cp index.html styles.css calendar-polish.css app.js manifest.json icon-512-v4.png build/岁时.app/Contents/Resources/
echo "Built build/岁时.app"
