class_name Player extends CharacterBody2D

static var node: Player
static var cam: Camera2D

@export var base_speed: float
@export_range(0, 2, 0.001, "or_greater") var bounce_bonus: float = 1.
@export var max_bonus_speed: float

@onready var sprite: Node2D = $Sprite
@onready var gpu_collision: GPUParticles2D = $CollisionParticle
@onready var test: CharacterBody2D = $Test
@onready var preview: Line2D = $Preview
@onready var gpu_wake: GPUParticles2D = $GPUWake
@onready var max_hp: TextureRect = %MaxHP
@onready var hp: TextureRect = %HP
@onready var health: Health = $Health
@onready var dmg_anim: AnimationPlayer = $DamageAnim


var twn_reflect: Tween

var latched_hook: Hook
var twn_latch: Tween
var twn_pulse: Tween

signal hook_latched(hook: Hook)
signal hook_released

const SLAM_SPARK = preload("res://objects/animations/slam_spark.tscn")
const WAVE = preload("res://objects/animations/wave.tscn")

func _ready() -> void:
	node = self
	cam = $Camera2D
	await get_tree().create_timer(0.5).timeout
	velocity = base_speed * Vector2.from_angle(randf_range(0, TAU))

func _physics_process(delta: float) -> void:
	gpu_wake.emitting = !is_instance_valid(latched_hook)
	gpu_wake.rotation = velocity.angle()
	gpu_wake.global_position = global_position
	dmg_anim.play(&"RESET" if health.can_harm else &"pulse")
	if !latched_hook:
		cam.position = velocity.normalized() * 32
		preview.hide()
		var coll = move_and_collide(velocity * delta)
		if coll:
			gpu_collision.global_position = global_position
			gpu_collision.rotation = coll.get_normal().angle()
			gpu_collision.restart()
			var inst = WAVE.instantiate()
			get_tree().current_scene.add_child(inst)
			inst.global_position = global_position
			inst.reset_physics_interpolation()
			velocity = velocity.bounce(coll.get_normal()) * bounce_bonus
			velocity = velocity.limit_length(max_bonus_speed)

			if twn_reflect: twn_reflect.kill()
			sprite.rotation = coll.get_normal().angle()
			sprite.scale = Vector2(0.5, 2)

			twn_reflect = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING).set_parallel()
			twn_reflect.tween_property(sprite, ^"scale", Vector2(1.45, 0.75), .25)
			twn_reflect.tween_property(sprite, ^"rotation", velocity.angle(), .25)
	else:
		cam.position = get_local_mouse_position().limit_length(64)
		velocity = Vector2()
		preview.show()
		preview.clear_points()
		sprite.rotation = get_local_mouse_position().angle()
		test.global_position = global_position
		test.velocity = get_local_mouse_position().normalized() * base_speed
		global_position = latched_hook.global_position
		var bounces: int
		preview.add_point(test.global_position)
		while bounces < 2:
			var test_coll = test.move_and_collide(test.velocity)
			if test_coll:
				test.velocity = test.velocity.bounce(test_coll.get_normal())
				bounces += 1
			preview.add_point(test.global_position)

		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			latched_hook.hook_released.emit(self, get_local_mouse_position().normalized())
			latched_hook = null
			velocity = get_local_mouse_position().normalized() * base_speed
			twn_pulse.kill()
			hook_released.emit()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !latched_hook and area is Hook:
		latched_hook = area
		area.hook_latched.emit(self)
		hook_latched.emit(area)
		#var spark = SLAM_SPARK.instantiate()
		#get_tree().current_scene.add_child(spark)
		#spark.global_position = area.global_position
		#spark.global_rotation = velocity.angle()
		#spark.reset_physics_interpolation()
		if twn_reflect: twn_reflect.kill()

		sprite.scale = Vector2.ONE

		twn_latch = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING).set_parallel()
		twn_latch.tween_property(self, ^"global_position", area.global_position, 0.2)
		twn_pulse = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops()
		twn_pulse.tween_property(sprite, ^"scale", Vector2(1.25, 0.9), 0.125)
		twn_pulse.tween_property(sprite, ^"scale", Vector2(2, 0.5), 0.125)
		health.can_harm = false
		await get_tree().create_timer(0.35).timeout
		health.can_harm = true

func _on_hurtbox_hitbox_entered(hitbox: Hitbox) -> void:
		get_tree().paused = true
		await get_tree().create_timer(0.05).timeout
		get_tree().paused = false
		var spark = SLAM_SPARK.instantiate()
		get_tree().current_scene.add_child(spark)
		spark.global_position = hitbox.global_position
		spark.global_rotation = velocity.angle()
		spark.reset_physics_interpolation()

var twn_health: Tween

func _on_health_harmed(amount: float) -> void:
	if twn_health: twn_health.kill()
	twn_health = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_health.tween_property(hp, ^"size:x", health.health * 16, 0.15)

func _on_health_healed(amount: float) -> void:
	if twn_health: twn_health.kill()
	twn_health = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_health.tween_property(hp, ^"size:x", health.health * 16, 0.15)
