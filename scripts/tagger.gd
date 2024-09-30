extends Control

var point = preload("res://scenes/Point.tscn")
var pic_path: String = "/home/heli/Pictures/Wallpapers/persona"

@export var is_paint_enabled: bool = true
@export var is_crt_enabled: bool = true

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/PictureContainer/MarginContainer/ScrollContainer/GridContainer
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var file_dialog: FileDialog = $PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/ScrollContainer/VBoxContainer/Open/FileDialog

const supported_formats := ["bmp", "jpg", "jpeg", "png", "tga", "svg", "webp", "exr", "hdr", "ktx", "dds"]

func get_all_files(path: String) -> Array:
	var result = []
	var dir = DirAccess.open(path)

	var files = dir.get_files()
	var dirs = dir.get_directories()
	for file in files:
		if (file.get_extension() in supported_formats):
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

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("mmb"):
		destruct()
		Global.current_mode = Global.modes.tagging
		for pic: Picture in Global.selected_pictures.keys():
			var copic = point.instantiate()
			copic.global_position = pic.global_position
			$CopyLayer.add_child(copic)
			copic.scale = Vector2(0.0, 0.0)

func destruct() -> void:
	for child in $CopyLayer.get_children():
		$CopyLayer.remove_child(child)

func _on_v_box_container_destruct_points() -> void:
	destruct()
