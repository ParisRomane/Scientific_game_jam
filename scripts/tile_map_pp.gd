extends TileMap

var used_cells

# Called when the node enters the scene tree for the first time.
func _ready():
	used_cells = get_used_cells(1)
	for cell in used_cells :
		#print(map_to_local(cell))
		#print(get_cell_atlas_coords(1, cell))
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_hit(collision, damage):
	var cell = local_to_map(collision.get_position() - collision.get_normal()*60)
	set_cell(1, cell, -1, Vector2i(7, 1))
