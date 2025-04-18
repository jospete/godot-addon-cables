# Player Health example

Damage the player until the game-over screen appears.

Run the `example_player_health_main` scene. The player script listens for the damage keybind action, and applies damage to the player when it is pressed.
When the player is damaged, health values are updated and sent along the `player_health_value` and `player_health_ratio_value` Cables.
When the player's health reaches zero, the `player_death_event` Cable is triggered with a `VOID_EVENT`.

Try running the `player` scene in isolation - none of the `notify` calls will break!
