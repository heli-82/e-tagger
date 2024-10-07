class_name NewTagDialog
extends Control

signal new_tag(name: String)


func grab_cursor() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/LineEdit.grab_focus()


func _on_ok_pressed() -> void:
	var text: String = $PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	emit_signal("new_tag", text)
	$PanelContainer/MarginContainer/VBoxContainer/LineEdit.clear()
	hide()

func _on_cancel_pressed() -> void:
	$PanelContainer/MarginContainer/VBoxContainer/LineEdit.clear()
	hide()
