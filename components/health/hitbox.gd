extends Area2D
class_name Hitbox

@export var health: Health
@export var team: Health.Team

@warning_ignore("unused_signal")
signal hurtbox_entered(hurtbox: Hurtbox)

func _ready() -> void:
	health.died.connect(_died)

func _died() -> void:
	if team == Health.Team.ENEMY:
		WaveManager.enemy_died.emit(health)
