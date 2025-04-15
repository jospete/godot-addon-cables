## A resource-based signal type.
## Bridges the gap between scene assets, and fixes the issue of
## signal connections getting broken when rearranging scenes.
@icon("res://addons/cables/icons/cable-icon.svg")
class_name Cable extends Resource

## Special value to indicate `void_notify()` was called.
## Needed because `null` can't be used for void events, otherwise
## the calls `notify(null)` and `void_notify()` would be ambiguous.
const VOID_EVENT := {}

## Utility to check if the value was produced from a `void_notify()` call.
static func is_void_event(value: Variant) -> bool:
	return typeof(value) == typeof(VOID_EVENT) and value == VOID_EVENT

var _current_value: Variant = null
var _did_emit_once: bool = false

# Core signal event that this cable wraps.
# This should not be used directly - instead, use the
# `link()` / `unlink()` methods.
signal _value_updated(value: Variant)

## When true, will re-emit the last value update
## to all `Callables` registered via `link()`.
## This solves the issue of late registration where
## the cable value has already settled before some consumer
## is ready to start watching for changes.
@export var replay_on_link := false

## When true, will print all interactions with this cable to the console
@export var debug_trace := false

## Optional description indicating intended use of
## this particular cable resource.
## This is for documentation purposes only, to
## keep your game organized as the number of cable resources grows.
@export_multiline var debug_description := ""

## True if this Cable has emitted at least one value.
## This will help determine when the value should be replayed.
var did_emit_once: bool:
	get: return _did_emit_once

## The last emitted value.
## This can be compared against the value received from `link()` where
## this would be the old value, and the value in the `link()` callable
## would be the new value.
var current_value: Variant:
	get: return _current_value
	set(value): notify(value)

func debug_log(message: String) -> void:
	if debug_trace: print("[%s] %s" % [resource_path.get_file(), message])

## Produce a new value to be passed on to any `CableValueConsumer` instances.
func notify(value: Variant) -> void:
	_value_updated.emit(value)
	_current_value = value
	_did_emit_once = true

## Produce a special `VOID_EVENT` value to to any `CableValueConsumer` instances.
## This should be used if the cable is intended to be strictly an event producer,
## and does not need to supply any specific value change
## (e.g. for a `player death` event).
func void_notify() -> void:
	debug_log("void_notify()")
	notify(VOID_EVENT)

## Registers the given `Callable` to this cable.
## The given `Callable` will be updated with the latest value
## whenever `notify()` or `void_notify()` is called on this Cable.
##
## If this Cable has emitted at least one value, and is set up to
## replay values, the given `Callable` will be called immediately
## with the latest value.
##
## Does nothing if the given callable is already connected to this Cable.
##
## Returns a `Callable` that, when called, will deregister
## the originally passed in `Callable` function.
func link(callable: Callable) -> Callable:
	if not _value_updated.is_connected(callable):
		debug_log("link")
		_value_updated.connect(callable)
	
	if replay_on_link and did_emit_once:
		debug_log("replay_on_link")
		callable.call(current_value)
	
	var unlink_action := func(): unlink(callable)
	
	return unlink_action

## Deregisters the given `Callable` from this cable.
## Does nothing if the `Callable` is not connected.
func unlink(callable: Callable) -> void:
	if _value_updated.is_connected(callable):
		debug_log("unlink")
		_value_updated.disconnect(callable)

## Links the given `Callable`, and will automatically unlink it
## when the given `NodeWithLifetime` instance is about to be
## deleted (i.e. when a `NOTIFICATION_PREDELETE` event is received on it).
##
## This is a more optimal alternative to `tree_enterd` / `tree_exiting` events,
## which may fire multiple times if a node is reparented one or more times.
func link_until_destroyed(node: NodeWithLifetime, callable: Callable) -> void:
	debug_log("link_until_destroyed(%s)" % node.name)
	var unlink_action := link(callable)
	node.node_destroyed.connect(unlink_action)
