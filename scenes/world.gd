extends Node2D

@onready var wall: StaticBody2D = $StaticBody2D

const SPAWNER = preload("res://objects/spawner/spawner.tscn")
const HOOK = preload("res://objects/hook/hook.tscn")

func _ready() -> void:
	WaveManager.enemy_died.connect(_on_enemy_died, CONNECT_DEFERRED)
	WaveManager.wave_started.connect(_on_wave_started, CONNECT_DEFERRED)
	WaveManager.wave_started.emit.call_deferred()

func _on_enemy_died() -> void:
	var enemies := get_tree().get_nodes_in_group(&"enemy")
	print("enemy died, array size == ", enemies.size())
	if enemies.size() <= 1:
		WaveManager.wave_started.emit()

func _on_wave_started() -> void:
	print("wave started")
	WaveManager.spawn_count += [0,1,1,1,2,2,3].pick_random()
	for i in [0,0,1,1,1,1,2,2,3,4].pick_random():
		if get_tree().get_nodes_in_group(&"world_hook").size() > 1:
			var hook_to_free := get_tree().get_first_node_in_group(&"world_hook")
			if hook_to_free != Player.node.latched_hook:
				hook_to_free.queue_free()
	for i in [1,1,1,1,2,2,2,3].pick_random():
		var inst = HOOK.instantiate()
		add_child(inst)
		var rect = Rect2(wall.rect).grow(96)
		inst.global_position = wall.to_global(Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y)))
		inst.reset_physics_interpolation()
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.33).timeout
	for i in WaveManager.spawn_count:
		var inst = SPAWNER.instantiate()
		add_child(inst)
		var rect = Rect2(wall.rect).grow(-32)
		inst.global_position = wall.to_global(Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y)))
		inst.reset_physics_interpolation()
		await get_tree().create_timer(0.1).timeout
