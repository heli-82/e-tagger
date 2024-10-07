extends Control

signal reload(tag: String)

func drop_pics() -> void:
	print(Global.current_tag_name, Global.selected_pictures)
	if Global.current_tag_name == "":
		return
	Global.current_mode = Global.modes.selecting
	for img in Global.get_selected_paths():
		print(img, Global.current_tag_name)
		Db.detach_tag(img, Global.current_tag_name)
	$"../ScrollContainer/VBoxContainer".destruct()
	emit_signal("reload", Global.current_tag_name)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if Global.current_mode==Global.modes.tagging:
			drop_pics()
		Global.clear_selection()
