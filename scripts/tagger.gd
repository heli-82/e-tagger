extends Control

#var pic_path: String = "/home/heli/Pictures/Wallpapers/persona"
var pic_path: String = "/home/heli/Pictures/Wallpapers/persona"
# Called when the node enters the scene tree for the first time.

func get_all_files(path: String) -> Array:
	var result = []
	var dir = DirAccess.open(path)

	var files = dir.get_files()
	var dirs = dir.get_directories()
	for file in files:
		result.append(path + "/" + file)

	for directory in dirs:
		var next_dir = path + "/" + directory
		result.append_array(get_all_files(next_dir))
	
	return result

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/PictureContainer/MarginContainer/GridContainer

func _ready() -> void:
	var files = get_all_files(pic_path)
	grid_container.drop()
	grid_container.set_pictures(files)
