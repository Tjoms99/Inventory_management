import time
import requests
from mfrc522 import SimpleMFRC522
import RPi.GPIO as GPIO
from config import *

api_endpoint = "http://192.168.43.90/dashboard/flutter_db/totem/addTotem.php"
reader = SimpleMFRC522()


def main():
    totem_id = config()
    while True:
        rfid, text = reader.read()
        rfid = hex(rfid)
        data = {'totem_id': totem_id, 'rfid': rfid}
        r = requests.post(url=api_endpoint, data=data)
        time.sleep(3)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        GPIO.cleanup()
