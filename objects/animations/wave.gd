extends AnimationPlayer

func _on_animation_finished(_anim_name: StringName) -> void:
	owner.queue_free()
