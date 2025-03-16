class_name ObjectPool extends Object

## holds individual pools, stored as dictionaries
## key : Node = node
## value : bool = stashed (true = stashed, false = spawned)
## see [NodePooler] for usage
static var pools : Dictionary = {}

## a global option for stashing a node, prefer using NodePooler when possible, since it has other utilities
## most commonly, it should be used for objects that eventually stash themselves, since poolers can be freed.
static func stash(unstashed_node: Node, pool_name: StringName, auto_disable: bool = true) -> void:
	if pools[pool_name].has(unstashed_node) and pools[pool_name][unstashed_node] == true:
		push_warning("Attempted to stash an already stashed node. Continuing")
		return
	pools[pool_name][unstashed_node] = true
	if auto_disable:
		unstashed_node.process_mode = Node.PROCESS_MODE_DISABLED
		if unstashed_node is CanvasItem: unstashed_node.visible = false
