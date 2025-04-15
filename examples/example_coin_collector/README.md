# Coin Collector example

Click on coins and watch a score counter go up

Run the `example_coin_collector_main` scene. The coins detect when they are clicked, and notify a `score_cable` resource that it should be incremented. The `counter_display` scene listens to the `score_cable` resource for values and automatically updates a label based on the emitted values.

Try deleting and re-adding the counter display while the game is running!
