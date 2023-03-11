extends Control
#enum elements type 
enum {CU,CO,NI,MG}
const MAX_SIZE_MAT = 9
var element_names = ["Ni","Co","Cu","Mg"]
var begin_text = [" Vitesse", " Cadence", " Minage DMG", " Enemis DMG"]

var next_texture = preload("res://NEXT.png")
var None_texture = preload("res://rond_smal_0.png")
var Ni_texture = preload("res://rond_small.png")
var Co_texture = preload("res://rond_smal_2.png")
var Cu_texture = preload("res://rond_smal_3.png")
var Mg_texture = preload("res://rond_smal_3.png")


#matrices des elements
var elements_matrix = []
var order_of_add = [0,2,4,1,7,5,8,3,6]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(MAX_SIZE_MAT) :
		self.get_node("stat_UI/hbox/matrix/"+str(i)).texture = None_texture
	#preload propriety
	var propriety = preload("res://propriety.tscn")
	for i in range(4):
		var instance_propriety = propriety.instantiate()
		instance_propriety.set_element_name( element_names[i])
		instance_propriety.set_description(": x1" +begin_text[i])
		$stat_UI/hbox/list_prop.add_child(instance_propriety)
	get_node("stat_UI/hbox/matrix/"+str(order_of_add[0])).texture = next_texture
	add_element(CO)
	add_element(CU)
	add_element(NI)
	
func add_element(element_type):
	if (len(elements_matrix) < MAX_SIZE_MAT):
		match element_type :
			CU :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[len(elements_matrix)])).texture =  Cu_texture
			CO :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[len(elements_matrix)])).texture =  Co_texture
			NI :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[len(elements_matrix)])).texture =  Ni_texture
			MG :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[len(elements_matrix)])).texture =  Mg_texture
		elements_matrix.append(element_type)
		update_proprieties()
		update_holder()
	# change text rect -> 
	
	# calcul des multiplcateurs, et update propriety -> est-ce fait ici ??
	pass

func mult(element):
	var s = 1
	for i in range(len(elements_matrix)):
		if (elements_matrix[i] == element ):
			# FONCTION VOISINS
			s+= 1
	return s

func update_proprieties():
	for i in range(4):
		$stat_UI/hbox/list_prop.get_child(i).set_description(": x"+ str(mult(i+1)) + begin_text[i])	

func update_holder(): 
	if (len(elements_matrix) < MAX_SIZE_MAT-1):
		get_node("stat_UI/hbox/matrix/"+str(order_of_add[len(elements_matrix)])).texture =  next_texture


func update_alive(nb_alive): 
	# signal ? ou global a un signal et ici est appellé ?
	$Container/hbox/nb_alive.text = ": "+str(nb_alive)
