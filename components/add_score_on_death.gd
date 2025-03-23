class_name AddScoreOnDeath extends Node

@export var health: Health
@export var amount: int

func _ready() -> void:
	health.died.connect(_died)

func _died() -> void:
	Player.add_to_score(amount)
