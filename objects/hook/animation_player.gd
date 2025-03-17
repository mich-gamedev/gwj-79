extends AnimationPlayer

var twn_spin: Tween
var twn_recoil: Tween

@onready var hook_outer: Node2D = $"../HookOuter"
@onready var hook_inner: Node2D = $"../HookInner"

func _ready() -> void:
	hook_inner.scale = Vector2.ZERO
	hook_outer.scale = Vector2.ZERO
	var twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel()
	twn.tween_property(hook_inner, ^"scale", Vector2.ONE, 0.15)
	twn.tween_property(hook_outer, ^"scale", Vector2.ONE, 0.3)

func _on_area_2d_hook_released(_player: Player, direction: Vector2) -> void:
	hook_inner.z_index = 0
	hook_inner.rotation = snapped(direction.angle(), PI/2)
	hook_outer.rotation = snapped(direction.angle(), PI/2)
	play(&"RESET")
	play(&"release")
	if twn_spin: twn_spin.kill()
	twn_spin = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	speed_scale = 3
	twn_spin.tween_property(self, ^"speed_scale", 0, 2)
	if twn_recoil: twn_recoil.kill()
	twn_recoil = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_recoil.parallel().tween_property(hook_inner, ^"position", Vector2(6, 0).rotated(direction.angle()), 0.25)
	twn_recoil.parallel().tween_property(hook_outer, ^"position", Vector2(2, 0).rotated(direction.angle()), 0.25)
	twn_recoil.set_trans(Tween.TRANS_SPRING).tween_property(hook_inner, ^"position", Vector2(), 1)
	twn_recoil.parallel().tween_property(hook_outer, ^"position", Vector2(), 1)
	await twn_spin.finished
	play(&"RESET")

func _on_area_2d_hook_latched(player: Player) -> void:
	hook_inner.z_index = -10
	if twn_recoil: twn_recoil.kill()
	twn_recoil = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	twn_recoil.tween_property(hook_inner, ^"position", Vector2(1.5, 0).rotated(player.velocity.angle()), 0.25)
	twn_recoil.parallel().tween_property(hook_outer, ^"position", Vector2(3, 0).rotated(player.velocity.angle()), 0.25)
	twn_recoil.set_trans(Tween.TRANS_SPRING).tween_property(hook_inner, ^"position", Vector2(), 1)
	twn_recoil.parallel().tween_property(hook_outer, ^"position", Vector2(), 1)
