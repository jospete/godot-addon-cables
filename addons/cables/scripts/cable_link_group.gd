## Utility to combine [method Cable.link] calls, and
## eliminate some deregistration boilerplate.
class_name CableLinkGroup extends RefCounted

var _actions: Array[Callable] = []

## Appends the given array of [code]Callable[/code]s to this group,
## while leaving any already-registered [code]Callable[/code]s in-tact.
## [br][br]
## This can be chained multiple times without causing any deregistration.
## [br][br]
## If you would like to instead [i]overwrite[/i] the currently stored
## [code]Callable[/code]s in this group, use [method collect] instead.
func append(unlink_actions: Array[Callable]) -> CableLinkGroup:
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
## var deregister_all := CableLinkGroup.new().aggregate([
##     CableLinkGroup.new().aggregate(deregister_group_1),
##     CableLinkGroup.new().aggregate(deregister_group_2),
##     CableLinkGroup.new().aggregate(deregister_group_3),
## ])
## [/codeblock]
func aggregate(unlink_actions: Array[Callable]) -> Callable:
	append(unlink_actions)
	return unlink_all

## Similar to [method aggregate], but deregisters any currently
## registered [code]Callable[/code]s via [method unlink_all]
## before appending the given [param unlink_actions] to this group.
## [br][br]
## Call this when you intend to re-use an existing [CableLinkGroup]
## to perform several "clean slate" hookups.
func collect(unlink_actions: Array[Callable]) -> Callable:
	unlink_all()
	return aggregate(unlink_actions)

## Unlinks all currently registered [code]Callable[/code]s that
## were registered via [method append], [method aggregate], or [method collect].
## [br][br]
## Note that [method collect] will call this before appending any new
## [code]Callable[/code]s to this group.
func unlink_all() -> void:
	for c in _actions: if c is Callable: c.call()
	_actions.clear()

## Convenience to reduce boilerplate of [method with_lifetime]
## by inferring [method NodeWithLifetime.from] while creating the new link group.
static func with_lifetime_of(node: Node) -> CableLinkGroup:
	return CableLinkGroup.with_lifetime(NodeWithLifetime.from(node))

## Creates a new [CableLinkGroup], and connects its
## [method unlink_all] method as a callable to the given
## [param lifetime]'s [signal NodeWithLifetime.node_destroyed] signal.
static func with_lifetime(lifetime: NodeWithLifetime) -> CableLinkGroup:
	var result := CableLinkGroup.new()
	lifetime.node_destroyed.connect(Callable(result, "unlink_all"))
	return result
