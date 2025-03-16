extends Node

@export var noise: FastNoiseLite
@export var body: Node2D
@export var speed: float = 24

var time: float

func _ready() -> void:
	noise.seed = randi()

func _physics_process(delta: float) -> void:
	time += delta
	body.global_position += Vector2(noise.get_noise_1d(time), noise.get_noise_1d(-time)) * speed * delta
