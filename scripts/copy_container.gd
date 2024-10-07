extends GridContainer

func _physics_process(delta: float) -> void:
	position = position.lerp((get_global_mouse_position() + Vector2(10.0, 10.0)), 12.0 * delta)
