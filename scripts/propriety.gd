extends Control

func set_element_name(name):
	$hbox/element_name.text = name

func set_description(desc):
	$hbox/description.text = desc
	
func set_texture(texture):
	$hbox/icon.texture = texture
