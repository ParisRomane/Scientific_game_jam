extends Control
#enum elements type 
enum {NONE, CU,CO,NI,MG}
const MAX_SIZE_MAT = 9
var element_names = ["Cu","Co","Ni","Mg"]
var begin_text = [" Vitesse", " Cadence", " Minage DMG", " Régen"]

var next_texture = preload("res://Assets/component/NEXT.png")
var None_texture = preload("res://Assets/component/rond_smal_0.png")
var Ni_texture = preload("res://Assets/component/rond_small.png")
var Co_texture = preload("res://Assets/component/rond_smal_2.png")
var Cu_texture = preload("res://Assets/component/rond_smal_3.png")
var Mg_texture = preload("res://Assets/component/rond_smal_3.png")
var nb_added = 0

#matrices des elements
var elements_matrix = [0,0,0,0,0,0,0,0,0]
var order_of_add = [0,2,4,1,7,5,8,3,6]

#signal
signal update_stat()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(MAX_SIZE_MAT) :
		self.get_node("stat_UI/hbox/matrix/"+str(i)).texture = None_texture
	#preload propriety
	var propriety = preload("res://scenes/propriety.tscn")
	for i in range(4):
		var instance_propriety = propriety.instantiate()
		instance_propriety.set_element_name( element_names[i])
		instance_propriety.set_description(": +1" +begin_text[i])
		$stat_UI/hbox/list_prop.add_child(instance_propriety)
	get_node("stat_UI/hbox/matrix/"+str(order_of_add[0])).texture = next_texture
	add_element(CU)
	add_element(CO)
	add_element(CU)
	add_element(NI)

	
func add_element(element_type):
	if (nb_added < MAX_SIZE_MAT):
		match element_type :
			CU :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[nb_added])).texture =  Cu_texture
			CO :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[nb_added])).texture =  Co_texture
			NI :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[nb_added])).texture =  Ni_texture
			MG :
				get_node("stat_UI/hbox/matrix/"+str(order_of_add[nb_added])).texture =  Mg_texture
		elements_matrix[order_of_add[nb_added]] = element_type
		nb_added+=1 
		update_proprieties()
		update_holder()

func update_proprieties():
	for i in range(4):
		$stat_UI/hbox/list_prop.get_child(i).set_description(": +"+ str(add(i+1)) + begin_text[i])	
	$mult.text = "Entropie accumulée : x"+ str(mult())
	
func update_holder(): 
	if (len(elements_matrix) < MAX_SIZE_MAT-1):
		get_node("stat_UI/hbox/matrix/"+str(order_of_add[nb_added])).texture =  next_texture


func update_alive(nb_alive): 
	# signal ? ou global a un signal et ici est appellé ?
	$Container/hbox/nb_alive.text = ": "+str(nb_alive)



func add(type):
	var s = 0
	for i in range(len(elements_matrix)):
		if (elements_matrix[i]==type):
			s+=1
	return s
	
func mult():
	#elements_matrix ext un array de taille 9, chaque entrée correspond a un materiau (0,1,2,ou 3)
	var mult=0
	var a
	#9 environnements correspondant à chaque element de matrice et ses plus proches voisins
	var env1=[elements_matrix[6]]+[elements_matrix[2]]+[elements_matrix[1]]+[elements_matrix[3]]
	var env2=[elements_matrix[7]]+[elements_matrix[0]]+[elements_matrix[2]]+[elements_matrix[4]]
	var env3=[elements_matrix[8]]+[elements_matrix[1]]+[elements_matrix[0]]+[elements_matrix[5]]
	var env4=[elements_matrix[0]]+[elements_matrix[5]]+[elements_matrix[4]]+[elements_matrix[6]]
	var env5=[elements_matrix[1]]+[elements_matrix[3]]+[elements_matrix[5]]+[elements_matrix[7]]
	var env6=[elements_matrix[2]]+[elements_matrix[4]]+[elements_matrix[3]]+[elements_matrix[8]]
	var env7=[elements_matrix[3]]+[elements_matrix[8]]+[elements_matrix[7]]+[elements_matrix[0]]
	var env8=[elements_matrix[4]]+[elements_matrix[6]]+[elements_matrix[8]]+[elements_matrix[1]]
	var env9=[elements_matrix[5]]+[elements_matrix[7]]+[elements_matrix[6]]+[elements_matrix[2]]
	var list_env=[env1,env2,env3,env4,env5,env6,env7,env8,env9]
	for i in range(list_env.size()):
		list_env[i].sort()
		#l'atome centrale ne se permute pas :
		list_env[i].append(elements_matrix[i])
	for i in range(list_env.size()):
		# on teste chaque environnemnt, si déjà présent, on passe au suivant
		for env_left in list_env.slice(i+1):
			a=1
			if list_env[i]==env_left || list_env[i][4] == 0 :
				a=0
				break
		mult+=a
	#return nombre d'env different
	return mult

