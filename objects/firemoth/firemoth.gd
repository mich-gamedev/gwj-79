extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const HOOK = preload("res://objects/hook/hook.tscn")

func _physics_process(delta: float) -> void:
	velocity.y += 64 * delta
	velocity.x = move_toward(velocity.x, 0.0, 64 * delta)

func _on_frame_changed() -> void:
	if sprite.frame == 0:
		velocity = global_position.direction_to(Player.node.global_position) * 96

func _on_health_died() -> void:
	var inst = HOOK.instantiate()
	get_tree().current_scene.add_child.call_deferred(inst)
	inst.global_position = global_position
	inst.reset_physics_interpolation()
