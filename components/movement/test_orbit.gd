extends CharacterBody2D

# this script orbits around a halfway point between the body and attractor, close but not quite what i want

@export var attracting_group: StringName = &"attractor"
@export var attractor_radius: float = 75
@export var tps: float = 60
@export_range(0, 1000, 0.01, "or_greater", "suffix:m/s", "hide_slider") var deceleration: float = 10
@export_range(0, 1) var bounce_damp: float = 1

var time_to_tick : float = randf_range(0, 1/tps)

var halfway_vec: Vector2

func _ready() -> void:
	_tick()
	velocity = halfway_vec.normalized().rotated(PI/2) * 160

func _physics_process(delta: float) -> void:

	time_to_tick -= delta
	if time_to_tick < 0:
		time_to_tick = 1/tps
		_tick()
	#velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	velocity += (halfway_vec.normalized() * ((velocity.length_squared()) / (halfway_vec.length()))) * delta
	velocity = velocity.normalized() * 160
	queue_redraw()

	var coll := move_and_collide(velocity * delta)
	if coll:
		velocity = velocity.bounce(coll.get_normal()) * bounce_damp


func _tick() -> void:
	var nearest_attractors = get_tree().get_nodes_in_group(attracting_group)
	nearest_attractors.sort_custom(sort_by_distance)
	var vec_to_attractor = to_local((nearest_attractors[0] as Node2D).global_position)
	halfway_vec = (vec_to_attractor + (vec_to_attractor.normalized() * attractor_radius)) / 2.0
	pass

func sort_by_distance(a: Node2D, b: Node2D) -> bool:
	return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position)

func _draw() -> void:
	draw_line(Vector2.ZERO, halfway_vec, Color.LIME_GREEN)
	draw_circle(halfway_vec, halfway_vec.length(), Color.DARK_GREEN, false)
