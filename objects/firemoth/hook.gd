extends Hook

@onready var target: Node2D = $Target

func _ready() -> void:
	await get_tree().process_frame
	target.global_position = global_position + Vector2.ONE

func _on_hook_released(player: Player, direction: Vector2) -> void:
	await get_tree().create_timer(0.1).timeout
	queue_free()
