import requests
from getmac import get_mac_address

import time
from mfrc522 import SimpleMFRC522
import RPi.GPIO as GPIO

api_endpoint = "http://192.168.1.201/dashboard/flutter_db/addTotem.php"
mac = get_mac_address()

reader = SimpleMFRC522()

def main():
	while True:
		rfid, text = reader.read()
		rfid = hex(rfid)
		data = {'mac':mac, 'rfid':rfid}
		r = requests.post(url = api_endpoint, data = data)
		time.sleep(3)

def terminate():
	GPIO.cleanup()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        terminate()	
	







