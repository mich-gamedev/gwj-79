extends Node
class_name CollideAndBounce

@export var body: CharacterBody2D
@export_range(0, 1, 0.01, "or_greater") var bounce_strength: float = 1

signal bounced()

func _physics_process(delta: float) -> void:
	var coll_info: KinematicCollision2D = body.move_and_collide(body.velocity * delta) as KinematicCollision2D

	if coll_info:
		bounced.emit()
		body.velocity = body.velocity.bounce(coll_info.get_normal()) * bounce_strength
