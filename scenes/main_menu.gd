extends Node2D

@onready var exit: Button = %Exit

func _ready() -> void:
	Settings.read_data()
	Pause.visibility_changed.connect(_pause_changed)
	if OS.get_name() == "Web":
		exit.hide()

func _on_play_pressed() -> void:
	SongManager.exit_filter()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed() -> void:
	Pause.show()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _pause_changed() -> void:
	if Pause.visible:
		SongManager.enter_filter(1, 1200)
	else:
		SongManager.enter_filter(1, 3500)
