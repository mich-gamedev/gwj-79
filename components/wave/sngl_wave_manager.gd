extends Node

signal enemy_died(health: Health)
signal wave_started

const enemy_list: Array[String] = [
	"res://resources/enemy_spawnrate/firefly.tres",
	"res://resources/enemy_spawnrate/firemoth.tres",
	"res://resources/enemy_spawnrate/glass_cannon.tres",
	"res://resources/enemy_spawnrate/shieldbug.tres",
]

var spawn_count: int = randi_range(1, 2)
var wave_idx: int = -1:
	set(v):
		if v != wave_idx:
			wave_idx = v
			rng_dict.clear()
			for path in enemy_list:
				print(path)
				var i : EnemySpawnRate = load(path)
				rng_dict[i] = i.curve.sample_baked(wave_idx)

var rng := RandomNumberGenerator.new()
var rng_dict: Dictionary

func rand_spawnrate() -> EnemySpawnRate:
	return rng_dict.keys()[rng.rand_weighted(PackedFloat32Array(rng_dict.values()))]

func _ready() -> void:
	wave_idx = 0
