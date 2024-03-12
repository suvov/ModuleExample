# Example of an iOS Feature Module implemented with a Redux-like Pattern

## Product and Technical Requirements
* Load a list of countries from the API.
* Load information from another API after the total number of countries is known.
* Support paging: Load the next page when reaching the bottom of the list.
* Support reload functionality.
* Display countries in a list with an information header.
* Utilize the Combine and SwiftUI frameworks.

## Types

* **Store**: Holds the State of the feature, calls the Reducer with dispatched Actions, and updates the State.
* **State**: Contains information needed to render the feature's UI and other helper data.
* **Action**: Enumeration of all possible changes to the State.
* **Reducer**: An object that, given an Action, mutates the State and optionally emits an Action publisher.
* **ActionCreator**: Creates an Action publisher from long-lasting work, such as a network call.
* **Adapter**: Converts "raw" types, such as API responses, into models ready to be rendered by the UI.
