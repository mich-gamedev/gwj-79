class_name PooledItem2D extends Node2D
##2D variant of [PooledItem], intended for pairing with [NodePooler], however [NodePooler] can be used without [PooledItem2D].
##contains signals and virtual functions for when it's stashed and unstashed, useful for controlling states like animations
##[br][b]WARNING:[/b] either it or a bullet must be scene owner, or it wont be called

##emitted when node is stashed [br][br][b]WARNING:[/b] only works if [method PooledItem.stash_item] is overridden with super()
signal stashed(pooler: NodePooler, pool_name: StringName)
##emitted when node is stashed [br][br][b]WARNING:[/b] only works if [method PooledItem.unstash_item] is overridden with super()
signal unstashed(pooler: NodePooler, pool_name: StringName)

func stash_item(pooler: NodePooler, pool_name: StringName) -> void: ## called when item is stashed by [NodePooler], use with super()
	stashed.emit(pooler,pool_name)

func unstash_item(pooler: NodePooler, pool_name: StringName) -> void: ## called when item is unstashed by [NodePooler], use with super()
	reset_physics_interpolation.call_deferred()
	unstashed.emit(pooler,pool_name)
