## Generic utility to aggregate [code]Callable[/code]s.
class_name CallableSink extends RefCounted

var _actions: Array[Callable] = []

## Appends the given array of [code]Callable[/code]s to this group,
## while leaving any already-registered [code]Callable[/code]s in-tact.
## [br][br]
## This can be chained multiple times without causing any deregistration.
## [br][br]
## If you would like to instead [i]overwrite[/i] the currently stored
## [code]Callable[/code]s in this group, use [method collect] instead.
func append(unlink_actions: Array[Callable]) -> CallableSink:
	if typeof(unlink_actions) == TYPE_ARRAY:
		_actions.append_array(unlink_actions)
	return self

## Similar to [method append], but returns a [code]Callable[/code]
## instead of a [code]self[/code] reference.
## [br][br]
## Useful in some edge cases where you may want to aggregate groups of groups
## like so:
## [br]
## [codeblock]
## var deregister_all := CallableSink.new().aggregate([
##     CallableSink.new().aggregate(deregister_group_1),
##     CallableSink.new().aggregate(deregister_group_2),
##     CallableSink.new().aggregate(deregister_group_3),
## ])
## [/codeblock]
func aggregate(unlink_actions: Array[Callable]) -> Callable:
	append(unlink_actions)
	return call_each_and_clear

## Similar to [method aggregate], but deregisters any currently
## registered [code]Callable[/code]s via [method unlink_all]
## before appending the given [param unlink_actions] to this group.
## [br][br]
## Call this when you intend to re-use an existing [CallableSink]
## to perform several "clean slate" hookups.
func collect(unlink_actions: Array[Callable]) -> Callable:
	call_each_and_clear()
	return aggregate(unlink_actions)

## Calls each currently registered [code]Callable[/code]
func call_each() -> void:
	for c in _actions: if c is Callable: c.call()

## Similar to [method call_each], but clears the [code]Callable[/code] cache
## after all currently registered [code]Callable[/code]s have run.
func call_each_and_clear() -> void:
	call_each()
	_actions.clear()
