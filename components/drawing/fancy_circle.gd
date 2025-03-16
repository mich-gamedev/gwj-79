@tool
class_name RingDraw extends Node2D

@export var active: bool = true
@export var width : float = 4.0
@export var radius : float = 24.0
@export_range(0, 360) var point_count: int = 72
@export var draw_color: Color = Color("f5ffe8")

func _physics_process(_delta: float) -> void:
	if active:
		visible = true
		queue_redraw()
	else:
		visible = false
func _draw() -> void:
	draw_arc(Vector2(), radius, 0, TAU, point_count, draw_color, width, false)
