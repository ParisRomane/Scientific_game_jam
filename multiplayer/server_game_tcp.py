from socket import *
import sys
import select
import json
 
# on construit la socket principale
socketprincipale = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
port = int(sys.argv[1])
socketprincipale.bind(('',port))
socketprincipale.listen(1)

data = [ ]
# on créé la liste de socket, avec le socketPrincipale pour le sélect
watcher_sockets = [socketprincipale]
# meme liste sans socketPrincipale, les socket pour réellement recevoir un message avec recv
clients = []


def update_game(sended,socket):
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
    	pass
    		
    
        




while True:
	# on regarde les sockets qui envoient des messages pour parler
	# si c'est une nouvelle socket on la voit comme socketPrincipale
	veutmeparler,_,_ = select.select(watcher_sockets, [], [])
	for s in veutmeparler: # on regarde dans tout les envois
		if s == socketprincipale: # si c'est un nouveau client
			(nouvellesocket,adr) = s.accept() #on l'accepte
			clients.append(nouvellesocket) #on l'ajoute aux deux listes de socket
			watcher_sockets.append(nouvellesocket)
			messageclient = bytes(str(data), 'utf-8')
			sent = nouvellesocket.send(messageclient)
		else: # si on connait deja la socket
			try:
				messageclient = s.recv(1000) # on recoit son message
				if len(messageclient) == 0: # si son message vaut 0 -> fin de communication
					# le client est parti, on l'enlèvèe des listes
					clients.remove(s) 
					watcher_sockets.remove(s)
					s.close()
				else: # il y a vraiment un message recu
					update_game(str(messageclient, 'utf-8'),s)
					for r in clients:
						sent = r.send(bytes(str(data), 'utf-8'))
			except ConnectionResetError:
				pass

