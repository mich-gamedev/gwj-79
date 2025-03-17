extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_body_towards: MoveBodyTowards = $MoveBodyTowards

const WAVE = preload("res://objects/animations/wave.tscn")

@onready var health: Health = $Hitbox/Health

func _ready() -> void:
	move_body_towards.offset = deg_to_rad(randf_range(-60,60))

func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.frame == 1:
		velocity.y -= 32
	if sprite.frame == 3:
		velocity.y += 32

func _on_health_died() -> void:
	var inst = WAVE.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	hide()
	await health.harmable_again
	queue_free()
