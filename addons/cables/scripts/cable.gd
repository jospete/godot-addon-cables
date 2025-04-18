## A resource-based signal type.
##
## Bridges the gap between scene assets, and fixes the issue of
## signal connections getting broken when rearranging scenes.
@icon("res://addons/cables/icons/cable-icon.svg")
class_name Cable extends Resource

## Special value to indicate [method void_notify] was called.
## [br][br]
## Needed because [code]null[/code] can't be used for void events, otherwise
## the calls [code]notify(null)[/code] and [code]void_notify()[/code] would be ambiguous.
const VOID_EVENT := {}

## Utility to check if the value was produced from a [method void_notify] call.
static func is_void_event(value: Variant) -> bool:
	return typeof(value) == typeof(VOID_EVENT) and value == VOID_EVENT

var _current_value: Variant = null
var _did_notify_once: bool = false

# Core signal event that this cable wraps.
# This should not be used directly - instead, use the
# `link()` / `unlink()` methods.
signal _value_updated(value: Variant)

## When [code]true[/code], will re-emit the last value update
## to all [code]Callable[/code]s registered via [method link].
## [br][br]
## This solves the issue of late registration where
## the cable value has already settled before some consumer
## is ready to start watching for changes.
@export var replay_on_link := false

## When [code]true[/code], will print all interactions with this cable to the console
@export var debug_trace := false

## Optional description indicating intended use of
## this particular cable resource.
## [br][br]
## This is for documentation purposes only, to
## keep your game organized as the number of cable resources grows.
@export_multiline var debug_description := ""

## [code]True[/code] if this Cable has emitted at least one value.
## [br]
## This will help determine when the value should be replayed.
var did_notify_once: bool:
	get: return _did_notify_once

## Alias of [member did_notify_once]
var did_emit_once: bool:
	get: return did_notify_once

## The last emitted value.
## [br][br]
## This can be compared against the value received from [method link] where
## this would be the old value, and the value in the [method link] callable
## would be the new value.
var current_value: Variant:
	get: return _current_value
	set(value): notify(value)

## Print contextual information for this cable to the console.
## [br]
## Does nothing when [member debug_trace] is [code]false[/code]
func debug_log(message: String) -> void:
	if debug_trace: print("[%s] %s" % [resource_path.get_file(), message])

## Convenience for obtaining the current value or a fallback,
## depending on the state of this cable.
func get_value_or_default(default_value: Variant) -> Variant:
	if did_notify_once and not Cable.is_void_event(current_value):
		return current_value
	return default_value

## Produce a new value to be passed on to any [code]Callable[/code]s registered
## via [method link], as well as any registered [CableValueConsumer] instances.
func notify(value: Variant) -> void:
	_value_updated.emit(value)
	_current_value = value
	_did_notify_once = true

## Produce a special [constant Cable.VOID_EVENT] value to to any registered listeners.
## [br][br]
## This should be used if the cable is intended to be strictly an event producer,
## and does not need to supply any specific value change
## (e.g. for a [b]player death[/b] event).
func void_notify() -> void:
	debug_log("void_notify()")
	notify(VOID_EVENT)

## Registers the given [code]Callable[/code] to this cable.
## [br][br]
## The given [code]Callable[/code] will be updated with the latest value
## whenever [method notify] or [method void_notify] is called on this Cable.
## [br][br]
## If this Cable has emitted at least one value, and is set up to
## replay values, the given [code]Callable[/code] will be called immediately
## with the latest value.
## [br][br]
## Does nothing if the given callable is already connected to this Cable.
## [br][br]
## Returns a [code]Callable[/code] that, when called, will deregister
## the originally passed in [code]Callable[/code] function.
func link(callable: Callable) -> Callable:
	if not _value_updated.is_connected(callable):
		debug_log("link")
		_value_updated.connect(callable)
	
	if replay_on_link and did_notify_once:
		debug_log("replay_on_link")
		callable.call(current_value)
	
	var unlink_action := func(): unlink(callable)
	
	return unlink_action

## Deregisters the given [code]Callable[/code] from this cable.
## [br]
## Does nothing if the [code]Callable[/code] is not connected.
func unlink(callable: Callable) -> void:
	if _value_updated.is_connected(callable):
		debug_log("unlink")
		_value_updated.disconnect(callable)

## Links the given [code]Callable[/code], and will automatically unlink it
## when the given [NodeWithLifetime] instance is about to be
## deleted (i.e. when a [b]NOTIFICATION_PREDELETE[/b] event is received on it).
## [br][br]
## This is a more optimal alternative to [b]tree_entered[/b] / [b]tree_exiting[/b] events,
## which may fire multiple times if a node is reparented one or more times.
func link_until_destroyed(node: NodeWithLifetime, callable: Callable) -> void:
	debug_log("link_until_destroyed(%s)" % node.name)
	var unlink_action := link(callable)
	node.node_destroyed.connect(unlink_action)
