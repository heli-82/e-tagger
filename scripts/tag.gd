class_name Tag
extends Control

var tag_name = "default_tag"

signal destruct_points

func set_tag(name: String) -> void:
	tag_name = name

func drop_pics() -> void:
	Global.current_mode = Global.modes.selecting
	get_parent().destruct()
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and Global.current_mode==Global.modes.tagging:
		drop_pics()
