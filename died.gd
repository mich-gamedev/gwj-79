extends CanvasLayer

const prompts = [
	"You may have fallen...\nBut you may rise again!!!",
	"To strive for improvement later,\nyou must fall right now.",
	"Huh, how'd that happen?",
	"A better world will be had,\neven if you can't see it anymore.",
	"These prompts don't even fit the game\nBut they're fun to write",
	"Testing... Testing... 1234",
	"It is 2:48PM on 25/03/23 as i write this",
]

@onready var prompt: RichTextLabel = %Prompt
@onready var waves_amount: Label = %WavesAmount
@onready var points_amount: Label = %PointsAmount

func _ready() -> void:
	get_tree().set_deferred(&"paused", true)
	prompt.text = "[center][wave]%s" % prompts.pick_random()
	prompt.visible_characters = 0
	SongManager.enter_filter()
	waves_amount.text = str(WaveManager.wave_idx)
	points_amount.text = str(Player.score)
	while prompt.visible_characters != prompt.text.length():
		prompt.visible_characters += 1
		await get_tree().create_timer(0.1).timeout

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
