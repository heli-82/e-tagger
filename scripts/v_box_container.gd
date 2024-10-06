extends VBoxContainer

var tag = preload("res://scenes/Tag.tscn")
signal destruct_points
signal tag_selected(tag: String)

func _ready() -> void:
	var tags: Array[String] = Db.get_tags()
	for tag_name in tags:
		var child: Tag = tag.instantiate()
		child.set_tag(tag_name)
		add_child(child)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("rmb"):
		Global.clear_selection()
		destruct()

func destruct() -> void:
	emit_signal("destruct_points")

func selected_tag(tag: String) -> void:
	emit_signal("tag_selected", tag)
