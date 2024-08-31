class_name Picture
extends Control

@onready var placeholder = preload("res://icon.svg")
var pba = PackedByteArray()

var picture_path: String = ""
var width: int = 128
var height: int = 128


func set_picture(path: String) -> void:
	picture_path = path
	var image = Image.new()
	image.load(picture_path)
	$PanelContainer/MarginContainer/TextureRect.texture = ImageTexture.create_from_image(image)
