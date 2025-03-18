extends Node2D

@onready var wall: StaticBody2D = $StaticBody2D

const SPAWNER = preload("res://objects/spawner/spawner.tscn")
const HOOKS: Array[PackedScene] = [
	preload("res://objects/hook/hook.tscn"), preload("res://objects/hook/hook.tscn"), preload("res://objects/hook/hook.tscn"),
	preload("res://objects/firemoth/hook.tscn")
]

func _ready() -> void:
	WaveManager.enemy_died.connect(_on_enemy_died, CONNECT_DEFERRED)
	WaveManager.wave_started.connect(_on_wave_started, CONNECT_DEFERRED)
	WaveManager.wave_started.emit.call_deferred()

func _on_enemy_died(health: Health) -> void:
	if is_instance_valid(health): await health.tree_exited
	var enemies := get_tree().get_nodes_in_group(&"enemy")
	print(enemies)
	print("enemy died, array size == ", enemies.size())
	if enemies.size() <= 0:
		WaveManager.wave_started.emit()

func _on_wave_started() -> void:
	print("wave started")
	WaveManager.spawn_count += [-1,0,0,0,1,1,1,1,1,2,2,2,3].pick_random()
	WaveManager.wave_idx += 1
	for i in [0,0,1,1,1,1,2,2,2,3,3,4,4,5].pick_random():
		if get_tree().get_nodes_in_group(&"world_hook").size() > 1:
			var hook_to_free := get_tree().get_first_node_in_group(&"world_hook")
			if hook_to_free != Player.node.latched_hook:
				hook_to_free.queue_free()
	for i in [1,1,1,1,2,2,2,3].pick_random():
		var inst = HOOKS.pick_random().instantiate()
		add_child(inst)
		var rect = Rect2(wall.rect).grow(48)
		inst.global_position = wall.to_global(Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y)))
		inst.reset_physics_interpolation()
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.33).timeout
	var remaining: float = WaveManager.spawn_count
	while remaining > 0:
		var spawnrate = WaveManager.rand_spawnrate()
		remaining -= spawnrate.cost
		var inst = SPAWNER.instantiate()
		inst.spawnrate = spawnrate
		add_child(inst)
		var rect = Rect2(wall.rect).grow(-32)
		inst.global_position = wall.to_global(Vector2(randf_range(rect.position.x, rect.end.x), randf_range(rect.position.y, rect.end.y)))
		inst.reset_physics_interpolation()
		await get_tree().create_timer(0.25).timeout
