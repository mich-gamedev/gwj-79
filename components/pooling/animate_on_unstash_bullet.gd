class_name BulletAnimateOnUnstash extends Bullet

@export var player: AnimationPlayer
@export var anim_name: StringName
@export var stash_on_finish: bool = true
@export var random_time_scale: Vector2 = Vector2.ONE


func unstash_item(pooler: NodePooler, pool_name: StringName) -> void:
	super(pooler, pool_name)
	player.play(&"RESET")
	player.speed_scale = randf_range(random_time_scale.x, random_time_scale.y)
	player.play(anim_name)
	if stash_on_finish:
		await player.animation_finished
		ObjectPool.stash(self, pool_name)
