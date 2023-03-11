extends Control
#enum elements type 
enum {CU,CO,NI,MG}
const MAX_SIZE_MAT = 9
var element_names = ["Ni","Co","Cu","Mg"]
var begin_text = [" Vitesse", " Cadence", " Minage DMG", " Enemis DMG"]

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
	pass # Replace with function body.
	add_element(CO)
	
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
	# change text rect -> 
	
	# calcul des multiplcateurs, et update propriety -> est-ce fait ici ??
	pass
	
func update_propriety(id_propriety, mult):
	$stat_UI/hbox/list_prop.get_child(id_propriety).set_description(": x"+ mult + begin_text[id_propriety])
	

