class_name NodePooler extends Node
##Pools scenes for regular spawning, to reduce node creation.
##Interacts with [ObjectPool], which contains a dictionary of each pool

##name of the pool to refer to in [ObjectPool] [br]if left empty, will be randomly generated at runtime (will be accessible through this property)
@export var pool_name: StringName
##Scene the pooler spawns if out of stashed nodes
@export var pool_scene: PackedScene
##amount of [param pool_scene] spawned in on-ready, more will be spawned if needed
@export var default_count: int = 8
##parent to spawn pooled objects [br]if left empty, will go to [member SceneTree.current_scene]
@export var default_parent: Node
## if true, stashed nodes will be automatically disabled and hidden
@export var auto_disable: bool = true

@warning_ignore("unused_signal")
signal node_created(node: Node)

func _ready() -> void:
	if !is_instance_valid(default_parent): default_parent = get_tree().current_scene
	if pool_name.is_empty():
		pool_name = str(randi())
		while ObjectPool.pools.has(pool_name):
			pool_name = str(randi())
	if !ObjectPool.pools.has(pool_name):
		ObjectPool.pools[pool_name] = {}
	if ObjectPool.pools[pool_name].size() < default_count:
		for i in default_count - ObjectPool.pools[pool_name].size():
			add_and_stash()


func update_for_valid() -> void:
	for i in ObjectPool.pools[pool_name].keys():
		if !is_instance_valid(i) or (i is Bullet and i.parried): ObjectPool.pools[pool_name].erase(i)

@warning_ignore("shadowed_variable")
func grab_available_object(unstash := true, fill_empty := true) -> Node:
	update_for_valid()
	var available: Array = ObjectPool.pools[pool_name].keys().filter(
		func(n): return ObjectPool.pools[pool_name][n] == true)
	if available.is_empty():
		assert(fill_empty, "pool of \"%s\" is empty, and (!fill_empty == true)" % pool_name)
		var new = add_and_stash() # instances new node
		if unstash: unstash(new)
		return new
	if unstash: unstash(available[0])
	return available[0]

func add_and_stash() -> Node:
	var inst = pool_scene.instantiate()
	default_parent.add_child.call_deferred(inst)
	stash(inst)
	return inst

func unstash(stashed_node: Node) -> void:
	if ObjectPool.pools[pool_name][stashed_node] == false:
		push_error("Attempted to unstash an already unstashed node. Continuing")
		return
	ObjectPool.pools[pool_name][stashed_node] = false
	if auto_disable:
		stashed_node.process_mode = Node.PROCESS_MODE_INHERIT
	if (stashed_node is PooledItem) or (stashed_node is PooledItem2D):
		if !stashed_node.is_node_ready(): await stashed_node.ready
		stashed_node.unstash_item(self, pool_name)
	if stashed_node is Bullet:
		stashed_node.bounces_left = stashed_node.bounces
		stashed_node.pool_name = pool_name
		if !stashed_node.is_node_ready(): await stashed_node.ready
		stashed_node.unstash_item(self, pool_name)
	if auto_disable and stashed_node is CanvasItem:
		stashed_node.show.call_deferred()

func stash(unstashed_node: Node) -> void:
	if ObjectPool.pools[pool_name].has(unstashed_node) and ObjectPool.pools[pool_name][unstashed_node] == true:
		push_error("Attempted to stash an already stashed node. Continuing")
		return
	ObjectPool.pools[pool_name][unstashed_node] = true
	if auto_disable:
		unstashed_node.process_mode = Node.PROCESS_MODE_DISABLED
	if (unstashed_node is PooledItem) or (unstashed_node is PooledItem2D) or (unstashed_node is Bullet):
		if !unstashed_node.is_node_ready(): await unstashed_node.ready
		unstashed_node.stash_item(self, pool_name)
	if auto_disable and unstashed_node is CanvasItem:
		unstashed_node.hide.call_deferred()
