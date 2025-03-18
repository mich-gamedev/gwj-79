extends AnimatableBody2D

@export var noise: FastNoiseLite

@onready var line: Line2D = $Line2D
@onready var shapes: Array[CollisionShape2D] = [
	$CollisionShape2D, $CollisionShape2D2, $CollisionShape2D3, $CollisionShape2D4
]

var rect: Rect2
var time: float

var last_points: PackedVector2Array

const HOOK = preload("res://objects/hook/hook.tscn")
const CORNER_PIECE = preload("res://assets/corner-piece.png")

func _physics_process(delta: float) -> void:
	time += delta
	rect = Rect2()
	for i in get_tree().get_nodes_in_group(&"hook"):
		if rect == Rect2(): rect = Rect2(to_local(i.global_position), Vector2())
		rect = rect.expand(to_local(i.global_position + Vector2(32,32)))
		rect = rect.expand(to_local(i.global_position - Vector2(32,32)))

	var new_points: Array[Vector2]
	new_points.append(Vector2(rect.position.x, rect.position.y))
	new_points.append(Vector2(rect.end.x, rect.position.y))
	new_points.append(Vector2(rect.end.x, rect.end.y))
	new_points.append(Vector2(rect.position.x, rect.end.y))

	#Player.cam.limit_left = rect.position.x - 128
	#Player.cam.limit_top = rect.position.y - 128
	#Player.cam.limit_right = rect.end.x + 128
	#Player.cam.limit_bottom = rect.end.y + 128
	if last_points.is_empty(): last_points = new_points
	last_points.resize(new_points.size())

	for i in new_points.size():
		new_points[i] += Vector2(noise.get_noise_2dv(new_points[i] + (Vector2.ONE * time)), noise.get_noise_2dv(-new_points[i]  + (Vector2.ONE * time))) * 24
		last_points[i] = last_points[i].lerp(new_points[i], 1 - 0.001 ** delta)
		shapes[i].position = last_points[i]
		(shapes[i].shape as WorldBoundaryShape2D).normal = last_points[i].direction_to(last_points[wrapi(i + 1, 0, last_points.size())]).rotated(PI/2)
	line.points = last_points
	queue_redraw()

func _draw() -> void:
	for i in last_points:
		draw_texture(CORNER_PIECE, i - Vector2(5,6))
