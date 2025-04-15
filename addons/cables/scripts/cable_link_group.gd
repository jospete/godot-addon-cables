## Utility to combine `Cable.link()` calls, and
## eliminate some deregistration boilerplate.
class_name CableLinkGroup extends RefCounted

var _actions: Array[Callable] = []

## Aggregates many `link()` return values.
## After this is called, call `unlink_all()` to deregister
## all passed in links at once.
func collect(unlink_actions: Array[Callable]) -> Callable:
	unlink_all()
	if typeof(unlink_actions) == TYPE_ARRAY:
		_actions.append_array(unlink_actions)
	return unlink_all

## Unlinks all currently registered `link()` calls.
func unlink_all() -> void:
	for c in _actions:
		if c is Callable:
			c.call()
	_actions.clear()
