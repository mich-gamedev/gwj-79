class_name Settings extends Resource

static var data: Settings

const path := "user://settings.tres"

@export var fullscreen: bool = false:
	set(v):
		fullscreen = v
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if v else DisplayServer.WINDOW_MODE_WINDOWED)
@export var pixel_perfect: bool = true:
	set(v):
		pixel_perfect = v
		Engine.get_main_loop().current_scene.get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT if v else Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
@export var music: float = 1.0:
	set(v):
		music = v
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"Music"), linear_to_db(v))
@export var sfx: float = 1.0:
	set(v):
		sfx = v
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(&"SFX"), linear_to_db(v))

static func read_data() -> void:
	if !data:
		if ResourceLoader.exists(path):
			data = load(path)
		else:
			data = new()
			save_data()
	data.fullscreen = data.fullscreen
	data.pixel_perfect = data.pixel_perfect
	data.music = data.music
	data.sfx = data.sfx

static func save_data() -> void:
	ResourceSaver.save(data, path)
