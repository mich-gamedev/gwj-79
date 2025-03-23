extends CharacterBody2D

@onready var gun: FireBullet = $Sprite2D/FireBullet
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Sprite2D/FireBullet/Timer
@onready var gpu_wind: GPUParticles2D = $Sprite2D/GPUParticles2D

const WAVE = preload("res://objects/animations/wave.tscn")

func _ready() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	sprite.rotate((PI/4 + PI/8) * delta)
	gpu_wind.global_scale = Vector2.ONE

func _on_timer_timeout() -> void:
	gpu_wind.emitting = true
	var twn := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	twn.tween_property(sprite, ^"scale", Vector2(0.5, 1.5), 0.5)
	twn.tween_property(sprite, ^"scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	await get_tree().create_timer(0.35).timeout
	gpu_wind.emitting = false
	await get_tree().create_timer(0.15).timeout
	var inst = WAVE.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	inst.reset_physics_interpolation()
	for i in 4:
		gun.fire_bullet(gun.global_rotation)
		velocity = -gun.global_transform.x * 72
		await get_tree().create_timer(0.1).timeout
	timer.start()
