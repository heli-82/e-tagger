class_name Tag
extends Control

var tag_name = "test_tag"

func set_tag(name: String) -> void:
	tag_name = name
	$PanelContainer/MarginContainer/Label.text = tag_name

func drop_pics() -> void:
	Global.current_mode = Global.modes.selecting
	for path in Global.get_selected_paths():
		Db.attach_tag(path, tag_name)
		#print(path)
	get_parent().destruct()
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if Global.current_mode==Global.modes.tagging:
			drop_pics()
		elif Global.current_mode==Global.modes.selecting:
			get_parent().selected_tag(tag_name)
