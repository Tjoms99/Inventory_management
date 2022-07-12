import string
import random
import RPi.GPIO as GPIO


def config():
    characters = string.ascii_letters + string.digits
    totem_id = ''.join(random.choice(characters) for i in range(8))
    try:
        f = open('config.txt', 'r')
        totem_id = f.readline()
        f.close()
    except:
        f = open('config.txt', 'w')
        f.write(totem_id)
        f.close()
    finally:
        return totem_id


if __name__ == '__main__':
    try:
        config()
    except KeyboardInterrupt:
        GPIO.cleanup()
