extends Button

var twn_hover: Tween
@export var normal_size: float = 80.
@export var hover_size: float = 128.

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered() -> void:
	if twn_hover: twn_hover.kill()
	twn_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_hover.tween_property(self, ^"custom_minimum_size:x", hover_size, 0.35)

func _mouse_exited() -> void:
	if twn_hover: twn_hover.kill()
	twn_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_hover.tween_property(self, ^"custom_minimum_size:x", normal_size, 0.35)
