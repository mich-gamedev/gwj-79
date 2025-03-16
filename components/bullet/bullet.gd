extends CharacterBody2D
class_name Bullet

@export var hurtbox: Hurtbox
@export var bounces: int

@onready var bounces_left = bounces

signal bounced
var pool_name: StringName
var parried: bool = false


func _physics_process(delta: float) -> void:
	var coll_info = move_and_collide(velocity * delta)
	if coll_info:
		bounced.emit()
		if bounces_left:
			bounces_left -= 1
			velocity = velocity.bounce(coll_info.get_normal())
		else:
			if parried: queue_free()
			else: ObjectPool.stash(self, pool_name)

@warning_ignore("unused_parameter", "shadowed_variable")
func unstash_item(pooler: NodePooler, pool_name: StringName) -> void:
	reset_physics_interpolation.call_deferred()

@warning_ignore("unused_parameter", "shadowed_variable")
func stash_item(pooler: NodePooler, pool_name: StringName) -> void:
	if parried: queue_free()
