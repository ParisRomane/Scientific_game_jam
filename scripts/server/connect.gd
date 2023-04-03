extends Container

var id = 0
signal co(msg)

func setup(data,id) :
	$ColorRect/pseudo_host.text = data["Player_1"]["pseudo"]
	$ColorRect/nb_participant.text = "nombres participant : "+ str(data["nb_joueur"])+ "/2"
	self.id = id
	
func _on_button_pressed():
	emit_signal("co", "LOBBY CONNECT "+str(id))
	
