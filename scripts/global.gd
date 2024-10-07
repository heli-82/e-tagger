extends Node

enum modes {tagging, selecting}
var current_mode = modes.selecting
var current_tag_name: String = ""
var selected_pictures := {}

func clear_selection() -> void:
	for pic in selected_pictures:
		pic.deselect_pic()
	selected_pictures.clear()

func add_to_selection(entity: Picture) -> void:
	selected_pictures[entity] = entity.picture_path

func remove_by_key(key: Picture) -> void:
	selected_pictures.erase(key)

func get_selected_paths() -> Array[String]:
	var paths: Array[String] = []
	for pic in selected_pictures.values():
		paths.append(pic)
	return paths

func create_symlinks(tag: String) -> void:
	var paths: Array[String] = Db.get_imgs(tag)
	print(paths)
