extends CharacterBody2D

@onready var fire_bullet: FireBullet = $FireBullet
@onready var line: Line2D = $Line2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var health: Health = $Hitbox/Health
@onready var sfx_scope: AudioStreamPlayer2D = $SFXScope

func _ready() -> void:
	Player.node.hook_latched.connect(_on_hook_latched)

func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(Player.node.global_position)
	line.points[1] = to_local(Player.node.global_position)

func _on_hook_latched(hook: Hook) -> void:
	print("firing bullet from glass cannon")
	sfx_scope.play()
	var twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	twn.tween_property(line, ^"width", 2.0, 0.35)
	twn.tween_property(sprite, ^"scale", Vector2(1.5, 0.75), 0.35)
	await get_tree().create_timer(0.5).timeout
	fire_bullet.fire_bullet(global_position.angle_to_point(Player.node.global_position))
	WaveManager.enemy_died.emit(health)
	queue_free()
