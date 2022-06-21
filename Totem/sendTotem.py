import requests
from getmac import get_mac_address

api_endpoint = "http://192.168.1.201/dashboard/flutter_db/addTotem.php"
mac = get_mac_address()
rfid = 123
data = {'mac':mac, 'rfid':rfid}
r = requests.post(url = api_endpoint, data = data)





