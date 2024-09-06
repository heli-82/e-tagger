extends Node

var selected_pictures := {}

func clear_selection() -> void:
	for pic in selected_pictures:
		pic.deselect_pic()
	selected_pictures.clear()

func add_to_selection(entity: Picture) -> void:
	selected_pictures[entity] = entity.picture_path

func remove_by_key(key: Picture) -> void:
	selected_pictures.erase(key)
