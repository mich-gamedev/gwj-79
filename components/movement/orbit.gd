class_name RigidOrbit extends Node

@export var body: RigidBody2D
@export var gravitating_body: Node2D
@export_placeholder("body > group") var gravitating_group: String
@export_range(0, 360, 0.01, "or_greater", "hide_slider", "suffix:px") var radius: float
@export_range(1, 360) var ray_count: int = 16
@export var tick_rate: float = 10

var tick: float:
	set(v):
		tick = wrapf(v, 0.0, 1.0/tick_rate)
		if v > 1.0/tick_rate:
			force_vector = _calculate_force()

var force_vector: Vector2

func _physics_process(delta: float) -> void:
	tick += delta

func _calculate_force() -> Vector2:
	if is_instance_valid(gravitating_body):
		pass
	elif gravitating_group:
		pass
	push_error("!is_instance_valid(gravitating_body) and gravitating_group.is_empty(), orbit failed")
	return Vector2()
