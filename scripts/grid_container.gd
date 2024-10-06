extends GridContainer

var picture_scene = preload("res://scenes/Picture.tscn")


func _ready() -> void:
	for i in range(10):
		add_child(picture_scene.instantiate())


func drop() -> void:
	for child in get_children():
		remove_child(child)


func change(paths: Array[String]) -> void:
	drop()
	set_pictures(paths)


func set_pictures_parallel(paths: Array) -> void :
	for path in paths:
		var thread = Thread.new()


func set_pictures(paths: Array[String]) -> void:
	for path in paths:
		var picture = picture_scene.instantiate()
		picture.set_picture(path)
		add_child(picture)
