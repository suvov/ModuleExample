# Example of a feature module implemented with a Redux-like pattern

## Types

### Main
* **Store**: An object that holds the State of the feature. It converts Events into State.
* **State**: Contains information needed to render the feature's UI and other helper data.
* **Event**: Enumerates events that can come from the UI or be created internally as a result of an Action.
* **Action**: An asynchronous result of work, such as calling a network API.
* **Reducer**: A simple function that updates the State with a given Action.

### Helper
* **ActionCreator**: Creates asynchronous Actions from long-lasting work, such as a network call.
* **Adapter**: Converts "raw" types such as API responses into models ready to be rendered by the UI.
* **Event filter**: A simple function that, given an Event and State, decides if the Event should be included or skipped.
* **Action filter**: A simple function that, given an Action and State, decides if the Action should be included or skipped.
* **Event creator**: A simple function that, given an Action and State, creates an Event if necessary.
