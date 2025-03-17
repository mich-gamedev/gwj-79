extends CharacterBody2D

func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(Player.node.global_position)
