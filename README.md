# godot-addon-cables

A Godot plugin to serve as an alternative to [Autoload Event Buses](https://www.gdquest.com/tutorial/godot/design-patterns/event-bus-singleton/),
primarily targeted for developers that [disagree with singleton pattern usage](https://stackoverflow.com/a/138012)
and dislike the idea of an infinitely expanding singleton class.

The implementation of this addon is very much inspired by [Ryan Hipple's 2017 Talk](https://www.youtube.com/watch?v=raQ3iHhE_Kk)
on using Unity `ScriptableObject`s as an alternative to singletons.

## Pros of Using Cables

- Each event gets its own dedicated `Cable` resource (no more re-opening the same singleton autoload script for the 50th time to add another event)
- `Cable` resources can be renamed freely without breaking code references (no more find / replace of `AutoloadClass.some_signal_name_that_changed`)
- Easily search for `Cable` event usage via Godot's built-in `Right Click > View Owners...` resource option
- Carry atomic data between scene reloads (Resources _are_ singletons, so they outlive the scene tree!)
- Easily test scenes in isolation (connecting to a `Cable` with no producers causes it to be _inert_ rather than exploding with undefined references)

## Example Usage

The general flow for usage is:

1. Right-click on any folder in the `FileSystem` tab > `Create New` > `Resource...`
2. Search for `Cable` > click `Create`
3. Name your Cable something useful like `player_death_event_cable.tres` or `player_health_value_cable.tres`
4. Produce values on the cable - this can be done by either using the `CableValueProducer` node for primitive values like `float`,`string`,`int`,`bool` etc, or using the `CableNodeValueProducer` node to emit `Node` references on the cable. (NOTE: the producer should generally be a child of the node that is producing the value)
5. Consume values from the cable - this can be done by adding the `CableValueConsumer` node as a child of the node that wishes to consume value updates

See the scenes in the `examples` folder for more granular details

## Usage Best Practices

It is best to use `Cable` resources for _global_ state, such has passing data to UI components (e.g. player health ratio to a healthbar widget) or sharing atomic data like enemy count, number of coins, or even a shared node reference to a manager script that holds these.

You should _not_ use `Cable` resources when transferring **local** state, such as watching a single monster's `CollisionShape2D.area_entered` event to apply damage to the monster (e.g., multiple instances of the monster scene will all broadcast on the same assigned `Cable` resource).
