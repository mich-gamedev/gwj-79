class_name AnimateOnUnstash2D extends PooledItem2D

@export var player: AnimationPlayer
@export var anim_name: StringName
@export var stash_on_finish: bool = true


func unstash_item(pooler: NodePooler, pool_name: StringName) -> void:
	super(pooler, pool_name)
	if player.has_animation(&"RESET"): player.play(&"RESET")
	player.play(anim_name)
	if stash_on_finish:
		await player.animation_finished
		ObjectPool.stash(self, pool_name)
