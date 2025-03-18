extends Node2D

var spawnrate: EnemySpawnRate

func spawn_enemy() -> void:
	var inst : Node2D = spawnrate.scene.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	inst.reset_physics_interpolation()
