from socket import *
import sys
import select
 
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


def update_lobby(sended,socket):
    global data
    if sended.startswith('LOBBY HOST'):
        sended = sended.split()
        json = {'max_joueur' : 4, 'nb_joueur' : 1, 'joueur1': {'pseudo': sended[2]}}
        data.append(json)
        print(data)
        
    elif sended.startswith('LOBBY CONNECT'):
        sended = sended.split()
        i = int(sended[2])
        nb_joueur = data[i]['nb_joueur']+1
        data[i]['nb_joueur'] = nb_joueur
        data[i]["joueur"+str(nb_joueur)] = {'pseudo': sended[3]}
        print(data)




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
					print(str(messageclient, 'utf-8')) # on l'affiche
					if str(messageclient, 'utf-8').startswith('LOBBY'):
						update_lobby(str(messageclient, 'utf-8'),s)
						for r in clients:
							sent = r.send(bytes(str(data), 'utf-8'))
					else :
						for r in clients:
							if (r != s ):
								sent = r.send(messageclient)
			except ConnectionResetError:
				pass
