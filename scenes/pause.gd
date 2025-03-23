extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event is InputEventKey: if event.keycode == KEY_ESCAPE and event.is_released():
		visible = !visible

func _on_pause_pressed() -> void:
	Settings.save_data()
	hide()

func _on_visibility_changed() -> void:
	get_tree().paused = visible

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	Settings.data.fullscreen = toggled_on

func _on_pixel_perfect_toggled(toggled_on: bool) -> void:
	Settings.data.pixel_perfect = toggled_on

func _on_music_slider_value_changed(value: float) -> void:
	Settings.data.music = value

func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.data.sfx = value
