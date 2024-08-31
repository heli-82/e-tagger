extends VBoxContainer

var tag = preload("res://scenes/Tag.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		add_child(tag.instantiate())
