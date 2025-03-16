extends StaticBody2D

@export var noise: FastNoiseLite

@onready var line: Line2D = $Line2D
@onready var polygon: CollisionPolygon2D = $CollisionPolygon2D

var rect: Rect2
var time: float

var last_points: PackedVector2Array

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

	for i in new_points.size():
		new_points[i] += Vector2(noise.get_noise_2dv(new_points[i] + (Vector2.ONE * time)), noise.get_noise_2dv(-new_points[i]  + (Vector2.ONE * time))) * 24
	polygon.polygon = PackedVector2Array(new_points)
	line.points = PackedVector2Array(new_points)
