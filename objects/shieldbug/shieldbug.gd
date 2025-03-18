extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var move_body_towards: MoveBodyTowards = $MoveBodyTowards
@onready var ring: RingDraw = $RingDraw

func _ready() -> void:
	anim.speed_scale = randf_range(0.8, 1.2)
	move_body_towards.offset = deg_to_rad(randf_range(-45,45))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity = global_position.direction_to(body.global_position) * body.velocity.length()

func reset_sonic_boom():
	ring.global_position = global_position
