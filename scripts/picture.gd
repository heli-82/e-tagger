class_name Picture
extends Control

var picture_path: String = ""

var is_available: bool = true
var is_hovered: bool = false
var is_selected: bool = false
var is_active: bool = true


var default_color: Color = Color("#dce3e9")
var default_border_color: Color = Color("#c2ced8")
var selected_color: Color = Color("#b193ba")
var selected_border_color: Color = Color("#84668e")

signal despawn
signal select
signal select_one
signal deselect
signal deselect_all

@onready var texture_rect: TextureRect = $PanelContainer/MarginContainer/TextureRect
@onready var panel_container: PanelContainer = $PanelContainer



func set_picture(path: String) -> void:
	picture_path = path
	var image = Image.new()
	image.load(picture_path)
	
	var height = image.get_height()
	var width = image.get_width()
	
	if max(height, width) > 600:
		var k = ceil(max(height, width)/600)
		image.resize(ceil(width/k), ceil(height/k))
	image.generate_mipmaps()
	$PanelContainer/MarginContainer/TextureRect.texture = ImageTexture.create_from_image(image)


func change_color(main_color: Color, border_color: Color) -> void:
	var stylebox: StyleBoxFlat = $PanelContainer.get_theme_stylebox("panel").duplicate()
	stylebox.set("bg_color", main_color)
	stylebox.border_color = border_color
	$PanelContainer.add_theme_stylebox_override("panel", stylebox)

func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false


func _physics_process(delta: float) -> void:
	if is_active:
		if is_hovered:
			if Input.is_action_just_pressed("click"):
				if !is_selected:
					select.emit()
				else:
					deselect.emit()

			scale = scale.lerp(Vector2(1.15, 1.15), 16.0 * delta)
		else:
			scale = scale.lerp(Vector2(1.0, 1.0), 16.0 * delta)
		
	if Input.is_action_just_pressed("rmb"):
			deselect_all.emit()


func select_pic() -> void:
	is_selected = true
	is_available = false
	change_color(selected_color, selected_border_color)


func deselect_pic() -> void:
	is_selected = false
	is_available = false
	change_color(default_color, default_border_color)


func _on_select() -> void:
	select_pic()
	Global.add_to_selection(self)


func _on_select_one() -> void:
	select_pic()
	Global.clear_selection()
	Global.add_to_selection(self)


func _on_deselect() -> void:
	deselect_pic()
	Global.remove_by_key(self)


func _on_deselect_all() -> void:
	Global.clear_selection()


func _on_despawn() -> void:
	$PanelContainer/MarginContainer/TextureRect.free()
