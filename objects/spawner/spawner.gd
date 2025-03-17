extends Node2D

func spawn_enemy() -> void:
	var inst : Node2D = load(WaveManager.enemy_list.pick_random()).instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	inst.reset_physics_interpolation()
