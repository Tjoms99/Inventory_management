import string
import random
import time
import requests
from mfrc522 import SimpleMFRC522
import RPi.GPIO as GPIO

api_endpoint = "http://192.168.43.90/dashboard/flutter_db/totem/addTotem.php"
reader = SimpleMFRC522()


def config():
    characters = string.ascii_letters + string.digits
    totem_id = ''.join(random.choice(characters) for i in range(8))
    try:
        f = open('config.txt', 'r')
        totem_id = f.readline()
        f.close()
    except:
        f = open('config.txt', 'w')
        f.write(id)
        f.close()
    finally:
        return totem_id


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
