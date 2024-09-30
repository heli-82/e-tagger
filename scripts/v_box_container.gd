extends VBoxContainer

var tag = preload("res://scenes/Tag.tscn")
signal destruct_points
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		add_child(tag.instantiate())

func destruct() -> void:
	emit_signal("destruct_points")
