extends AudioStreamPlayer

var twn_filter: Tween

@onready var filter: AudioEffectFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index(&"Music"), 0)

func enter_filter(time := 1, cutoff_hz := 1200.) -> void:
	if twn_filter: twn_filter.kill()
	twn_filter = create_tween()
	twn_filter.tween_property(filter, ^"cutoff_hz", cutoff_hz, time)

func exit_filter(time := 1) -> void:
	if twn_filter: twn_filter.kill()
	twn_filter = create_tween()
	twn_filter.tween_property(filter, ^"cutoff_hz", 20500, time)
