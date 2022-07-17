#!/bin/sh
/usr/bin/chromium-browser --kiosk --noerrdialogs http://192.168.43.90/dashboard/web &
python3 /home/pi/Documents/Inventory_management/src/totem/runRFID.py