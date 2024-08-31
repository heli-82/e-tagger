extends GridContainer

var picture = preload("res://scenes/Picture.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(10):
		add_child(picture.instantiate())

func drop() -> void:
	for child in get_children():
		remove_child(child)

func set_pictures_parallel(paths: Array) -> void :
	for path in paths:
		var thread = Thread.new()
		

func set_pictures(paths: Array) -> void:
	for path in paths:
		var picture = picture.instantiate()
		picture.set_picture(path)
		add_child(picture)
