extends StaticBody2D

@export var noise: FastNoiseLite

@onready var line: Line2D = $Line2D
@onready var polygon: CollisionPolygon2D = $CollisionPolygon2D

var rect: Rect2
var time: float

var last_points: PackedVector2Array

const HOOK = preload("res://objects/hook/hook.tscn")
const CORNER_PIECE = preload("res://assets/corner-piece.png")

func _physics_process(delta: float) -> void:
	time += delta
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
		last_points[i] = last_points[i].lerp(new_points[i], 1 - 0.00001 ** delta)
	polygon.polygon = last_points
	line.points = last_points
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var inst = HOOK.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.global_position = get_global_mouse_position()
		inst.reset_physics_interpolation()

func _draw() -> void:
	for i in last_points:
		draw_texture(CORNER_PIECE, i - Vector2(5,6))
