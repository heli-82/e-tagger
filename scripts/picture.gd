class_name Picture
extends Control

var picture_path: String = ""
var width: int = 128
var height: int = 128
var is_hovered: bool = false


func set_picture(path: String) -> void:
	picture_path = path
	var image = Image.new()
	image.load(picture_path)
	$PanelContainer/MarginContainer/TextureRect.texture = ImageTexture.create_from_image(image)


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	is_hovered = false


func _physics_process(delta: float) -> void:
	if is_hovered:
		scale = scale.lerp(Vector2(1.2, 1.2), 6.0 * delta)
	else:
		scale = scale.lerp(Vector2(1.0, 1.0), 6.0 * delta)
