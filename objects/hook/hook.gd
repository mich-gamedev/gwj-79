extends Hook

@onready var target: Node2D = $Target

func _ready() -> void:
	await get_tree().process_frame
	target.global_position = global_position + Vector2.ONE
