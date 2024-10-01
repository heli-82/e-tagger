
class_name Point
extends Control

func _physics_process(delta: float) -> void:
	scale = scale.lerp(Vector2(0.5, 0.5), 9.0 * delta)
	position = position.lerp(get_global_mouse_position(), 6.0 * delta)
