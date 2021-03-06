import time
import requests
from mfrc522 import SimpleMFRC522
import RPi.GPIO as GPIO

api_endpoint = "http://192.168.43.90/dashboard/flutter_db/totem/addTotem.php"
reader = SimpleMFRC522()


def config():
    try:
        f = open('config.txt', 'r')
        totem_id = f.readline()
        f.close()
    except:
        print("Waiting for RFID")
        totem_id, text = reader.read()
        totem_id = hex(totem_id).upper()
        totem_id = totem_id[2:-2]
        f = open('config.txt', 'w')
        f.write(totem_id)
        f.close()
        
        data = {'totem_id': totem_id, 'rfid': ''}
        r = requests.post(url=api_endpoint, data=data)
        print(data)
    finally:
        print("This is your totem ID:\n");
        print(totem_id)
        return totem_id

def main():
    totem_id = config()
    while True:
        rfid, text = reader.read()
        rfid = hex(rfid)
        rfid = rfid[2:-2]
        data = {'totem_id': totem_id, 'rfid': rfid}
        r = requests.post(url=api_endpoint, data=data)
        time.sleep(2)
        data = {'totem_id': totem_id, 'rfid': ''}
        r = requests.post(url=api_endpoint, data=data)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        GPIO.cleanup()
