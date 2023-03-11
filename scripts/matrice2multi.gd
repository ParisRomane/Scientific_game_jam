extends Node2D
func _matrice2mult(mx_vct):
	#mx_vct ext un array de taille 9, chaque entrée correspond a un materiau (0,1,2,3 ou 4)
	var mult=0
	var a=1
	#9 environnements correspondant à chaque element de matrice et ses plus proches voisins
	var env1=[mx_vct[1]]+[mx_vct[3]]+[mx_vct[4]]+[mx_vct[5]]+[mx_vct[7]]
	var env2=[mx_vct[6]]+[mx_vct[2]]+[mx_vct[0]]+[mx_vct[1]]+[mx_vct[3]]
	var env3=[mx_vct[7]]+[mx_vct[0]]+[mx_vct[1]]+[mx_vct[2]]+[mx_vct[4]]
	var env4=[mx_vct[8]]+[mx_vct[1]]+[mx_vct[2]]+[mx_vct[0]]+[mx_vct[5]]
	var env5=[mx_vct[0]]+[mx_vct[5]]+[mx_vct[3]]+[mx_vct[4]]+[mx_vct[6]]
	var env6=[mx_vct[2]]+[mx_vct[4]]+[mx_vct[5]]+[mx_vct[3]]+[mx_vct[8]]
	var env7=[mx_vct[3]]+[mx_vct[8]]+[mx_vct[6]]+[mx_vct[7]]+[mx_vct[0]]
	var env8=[mx_vct[4]]+[mx_vct[6]]+[mx_vct[7]]+[mx_vct[8]]+[mx_vct[1]]
	var env9=[mx_vct[5]]+[mx_vct[7]]+[mx_vct[8]]+[mx_vct[6]]+[mx_vct[2]]
	var list_env=[env1,env2,env3,env4,env5,env6,env7,env8,env9]
	for env in list_env:
		env.sort()
	for i in range(list_env.size()):
		a=1
		# on teste chaque environnemnt, si déjà présent, on passe au suivant
		for env_left in list_env.slice(i+1): 
			if list_env[i]==env_left:
				a=0
				break
		mult+=a
	#return nombre d'env differen
	return mult
	


# Called when the node enters the scene tree for the first time.
func _ready():
	print(_matrice2mult([4,4,4,0,0,0,0,0,0]))
	print(_matrice2mult([0,1,2,3,4,5,6,7,8,9]))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
