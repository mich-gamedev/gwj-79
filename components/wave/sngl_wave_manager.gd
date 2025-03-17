extends Node

signal enemy_died
signal wave_started

const enemy_list: Array[String] = [
	"res://objects/firefly/firefly.tscn",
	"res://objects/firemoth/firemoth.tscn",
	"res://objects/glass_cannon/glass_cannon.tscn",
	"res://objects/shieldbug/shieldbug.tscn",
]

var spawn_count: int = randi_range(1, 2)
var wave_idx: int = 0
