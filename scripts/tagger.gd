extends Control

var point = preload("res://scenes/Point.tscn")
var pic_path: String = "/home/heli/Pictures/Wallpapers/persona"

@export var is_paint_enabled: bool = false
@export var is_crt_enabled: bool = false

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/HBoxContainer/PictureContainer/MarginContainer/ScrollContainer/GridContainer
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var file_dialog: FileDialog = $PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/VBoxContainer/Open/FileDialog

const supported_formats := ["bmp", "jpg", "jpeg", "png", "tga", "svg", "webp", "exr", "hdr", "ktx", "dds"]

func get_all_files(path: String) -> Array[String]:
	var result: Array[String] = []
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
	Global.clear_selection()
	Global.current_tag_name = ""
	file_dialog.use_native_dialog = true
	file_dialog.add_filter("Directory")
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.popup()

func _on_file_dialog_dir_selected(dir: String) -> void:
	var files: Array[String] = get_all_files(dir)
	grid_container.change(files)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("export"):
		Global.create_symlinks(Global.current_tag_name)
	if Input.is_action_just_released("mmb"):
		destruct()
		Global.current_mode = Global.modes.tagging
		for pic: Picture in Global.selected_pictures.keys():
			var copic = point.instantiate()
			copic.global_position = pic.global_position
			copic.set_texture(pic.get_texture())
			$CopyLayer/CopyContainer.add_child(copic)


func destruct() -> void:
	for child in $CopyLayer/CopyContainer.get_children():
		$CopyLayer/CopyContainer.remove_child(child)



func _on_v_box_container_destruct_points() -> void:
	destruct()


func _on_v_box_container_tag_selected(tag: String) -> void:
	var imgs: Array[String] = Db.get_imgs(tag)
	grid_container.change(imgs)


func _on_new_tag_dialog_new_tag(name: String) -> void:
	print(name)
	Db.add_tag(name)
	$PanelContainer/MarginContainer/HBoxContainer/TagContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.set_tags()


func _on_new_tag_pressed() -> void:
	$CopyLayer/NewTagDialog.show()
	$CopyLayer/NewTagDialog.grab_cursor()


func _on_clear_reload(tag: String) -> void:
	var imgs: Array[String] = Db.get_imgs(tag)
	grid_container.change(imgs)


func _on_export_pressed() -> void:
	if Global.current_tag_name != "":
		Global.create_symlinks(Global.current_tag_name)
