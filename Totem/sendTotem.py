import time

import requests							# http request library
from getmac import get_mac_address		# library for getting device mac address

from mfrc522 import SimpleMFRC522		# RFID module library
import RPi.GPIO as GPIO					# Raspberry pi GPIO library

api_endpoint = "http://192.168.1.201/dashboard/flutter_db/addTotem.php"
mac = get_mac_address()

reader = SimpleMFRC522()

# Function waits for an RFID tag and makes a request to the web-server, and repeats. 
def main():
	while True:
		rfid, text = reader.read()
		rfid = hex(rfid)
		data = {'rfid':rfid}
		r = requests.post(url = api_endpoint, data = data)
		time.sleep(3)

def terminate():
	GPIO.cleanup()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        terminate()	
	







