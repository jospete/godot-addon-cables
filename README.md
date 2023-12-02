# godot-addon-cables

Signals transfer values, Cables transfer Signals

This addon solves the problem of signal connections getting broken when refactoring a world scene comprised of smaller "prefab" scenes. This is possible with the new `Cable` construct.

Normally for global event transfer we would just use a singleton script that acts as en event bus and proxies signal calls out to other listeners. However, this is rife with potential errors and renaming / reconfiguring these event functions is near impossible when the project is very large.

`Cable` resources solve this problem by breaking out each function that would be on that giant global event bus singleton into a single, trackable value.

## What does this addon fix?

- Signal connections no longer broken by function renaming
- Signal connections no longer broken by adding or deleting nodes
- Eliminates reference race conditions by forcing scripts to account for cases where a resource might not exist
- Allows for reference hot-swapping (e.g. replace all refrences to `ManagerScriptA` with `ManagerScriptB` seamlessly)
- `Cable` event resources can be renamed freely, and all references will automatically get updated (no more crawling through your scripts an renaming functions)


## Usage

### Cable

Whenever you are about to make a singleton script that has a signal on it, throw away that singleton script and make a `Cable` instead.

### CableListener

Watch `Cable` events with a `CableListener` node - simply add the listener node to a scene prefab and connect to its `next` signal.

### CableEmitter

Notify listeners that one of your manager/controller scripts is available for use. This also has the added benefit of being able
to swap out script instance refs as needed.

## Best Practices

- In general, scenes should not reach outside of their own "scope". For example, if you have a "coin" scene, and it needs to update a counter when it is clicked, the _counter_ should be a `Cable` value.

- `CableEmitter` instances should only point to top-level, long-lived controllers or nodes like `Camera2D` or some player save data script

- `CableListener` signal hooks should not be bound to outside of their scene scope - this would defeat the purpose of using cables at all.

## Examples

See the `coin_collector` example in this repo to see how the UI can be bound to a score event cable.