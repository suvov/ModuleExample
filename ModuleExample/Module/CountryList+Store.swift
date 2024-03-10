import Combine
import Foundation

protocol CountryListStoreProtocol: ObservableObject {
  var state: CountryList.State { get }
  func onEvent(_ event: CountryList.Event)
}

extension CountryList {
  final class Store: CountryListStoreProtocol {
    private let actionCreator: CountryListActionCreatorProtocol
    private var subscription: AnyCancellable?

    init(initialState: State = .initial,
         actionCreator: CountryListActionCreatorProtocol) {
      self.state = initialState
      self.actionCreator = actionCreator
      start()
    }

    @Published
    var state: State

    func onEvent(_ event: CountryList.Event) {
      events.send(event)
    }

    private let events = PassthroughSubject<Event, Never>()

    private func start() {
      subscription = events
        .receive(on: DispatchQueue.main)
        /* Filter events */
        .filter { [unowned self] event in
          Self.shouldIncludeEvent(event, state: self.state)
        }
        /* Create actions from events */
        .flatMap { [unowned self] event in
          self.createAction(with: event)
            .receive(on: DispatchQueue.main)
        }
        /* Filter actions */
        .filter { [unowned self] action in
          Self.shouldIncludeAction(action, state: self.state)
        }
        /* Side effects */
        .handleEvents(receiveOutput: { [unowned self] action in
          /* Dispatch event after action if needed */
          if let event = Self.createEventWithAction(action, state: self.state) {
            self.events.send(event)
          }
        })
        /* Reduce */
        .map { [unowned self] action in
          self.state.reduced(with: action)
        }
        /* Update state */
        .sink { [unowned self] state in
          self.state = state
        }
    }

    private func createAction(with event: Event) -> AnyPublisher<Action, Never> {
      switch event {
      case .loadFirst:
        return actionCreator.loadFirstPage()
      case .loadNext:
        return actionCreator.loadNextPage(state.pagination.next)
      case let .loadHeader(totalCount):
        return actionCreator.loadHeader(totalCount: totalCount)
      }
    }
  }
}

extension CountryList.Store {
  static func shouldIncludeEvent(
    _ event: CountryList.Event, state: CountryList.State
  ) -> Bool {
    switch event {
    /* Ignore load next if already loading or loaded all */
    case .loadNext:
      if state.isLoadingNextPage ||
        state.items.count >= state.pagination.totalCount {
        return false
      }
    default:
      break
    }
    return true
  }

  static func shouldIncludeAction(
    _ action: CountryList.Action, state: CountryList.State
  ) -> Bool {
    switch action {
    /* Ignore loaded page if it's not the one expected. Might happen after reload */
    case let .didLoadPage(payload):
      if payload.page != state.pagination.next {
        return false
      }
    /* Ignore loaded header if loading whole screen. Might happen after reload. */
    case .didLoadHeader:
      if state.screenState == .loading {
        return false
      }
    default:
      break
    }
    return true
  }

  static func createEventWithAction(
    _ action: CountryList.Action, state: CountryList.State
  ) -> CountryList.Event? {
    switch action {
    /* Load header after loaded page with total count */
    case let .didLoadPage(payload):
      guard state.header == nil else {
        return nil
      }
      return .loadHeader(payload.totalCount)
    default:
      return nil
    }
  }
}
