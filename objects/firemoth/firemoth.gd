extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const HOOK = preload("res://objects/firemoth/hook.tscn")

func _physics_process(delta: float) -> void:
	velocity.y += 48 * delta
	velocity.x = move_toward(velocity.x, 0.0, 128 * delta)

func _on_frame_changed() -> void:
	if sprite.frame == 0:
		velocity = global_position.direction_to(Player.node.global_position) * 96

func _on_health_died() -> void:
	var inst = HOOK.instantiate()
	get_tree().current_scene.add_child.call_deferred(inst)
	await inst.ready
	inst.global_position = global_position
	inst.reset_physics_interpolation()
	Player.node._on_area_2d_area_entered(inst)
