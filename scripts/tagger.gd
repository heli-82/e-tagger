extends Control

var pic_path: String = "/home/heli/Pictures/Wallpapers/persona"

@export var is_paint_enabled: bool = true
@export var is_crt_enabled: bool = true

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/PictureContainer/MarginContainer/ScrollContainer/GridContainer
#@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/PictureContainer/MarginContainer/GridContainer
@onready var file_dialog: FileDialog = $PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/VBoxContainer/Open/FileDialog

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


func _ready() -> void:
	if !is_paint_enabled:
		$PanelContainer/MarginContainer/HBoxContainer/PictureContainer/Panel.hide()
	if !is_crt_enabled:
		$CanvasLayer/ColorRect.hide()
	var files = get_all_files(pic_path)
	grid_container.change(files)


func _on_open_pressed() -> void:
	file_dialog.use_native_dialog = true
	file_dialog.add_filter("Directory")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.popup()


func _on_file_dialog_dir_selected(dir: String) -> void:
	pic_path = dir
	var files = get_all_files(pic_path)
	grid_container.change(files)
