# Emits the target node on ready to the target cable.
# Useful when you want to notify scripts that a manager-type class has become available,
# or if a singleton instance needs to be destroyed / recreated for whatever reason.
class_name CableEmitter extends Node

# The Cable resource to provide the value to
@export var cable: Cable

# The value to be provided.
# This should be a child node reference.
@export var value: Node

func _ready():
	# notify any listeners that the instance has become available
	if cable and value:
		cable.emit(value)
