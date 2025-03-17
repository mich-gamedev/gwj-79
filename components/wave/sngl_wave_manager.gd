extends Node

signal enemy_died
signal wave_started

const enemy_list: Array[String] = [
	"res://objects/firefly/firefly.tscn"
]

var spawn_count: int = randi_range(1, 2)
var wave_idx: int = 0
