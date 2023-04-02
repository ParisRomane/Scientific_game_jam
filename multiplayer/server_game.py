from socket import *
import sys
import select
import json
import time
import traceback



# on construit la socket principale
s = socket(AF_INET, SOCK_DGRAM)
s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
s.setsockopt(SOL_SOCKET, SO_BROADCAST, 1)

port = int(sys.argv[1])
s.bind(('',port))


 

print("UDP server up and listening")

 

data = [ ]
# on créé la liste de socket, avec le socketPrincipale pour le sélect
watcher_sockets = [s]
# meme liste sans socketPrincipale, les socket pour réellement recevoir un message avec recv
clients = []


def update_game(sended):
    global data
    try : 
        jsended = json.loads(sended)
        not_in_data = True
        for player in range(len(data)) :
            if data[player]['name'] == jsended['name'] :
                data[player] = jsended
                not_in_data = False
        if(not_in_data) :
            data.append(jsended)
    except json.decoder.JSONDecodeError :
        print(data)

n_time = time.time()
timer = 0.0
while 1:
    try:
        message, address = s.recvfrom(1024)
        if not(address in clients):
            clients.append(address)
            print(clients)
        update_game(str(message, 'utf-8'))
    except (KeyboardInterrupt, SystemExit):
        raise
    except:
        traceback.print_exc()
    timer += time.time() - n_time
    n_time = time.time()
    if (timer>0):
        timer = -0.016
        for r in clients:
            sent = s.sendto(bytes(str(data), 'utf-8'), address)
        

