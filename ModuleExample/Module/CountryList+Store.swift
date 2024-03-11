import Combine
import Foundation

protocol CountryListStoreProtocol: ObservableObject {
  var state: CountryList.State { get }
  func dispatchAction(_ action: CountryList.Action)
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

    func dispatchAction(_ action: Action) {
      actions.send(action)
    }

    private let actions = PassthroughSubject<Action, Never>()

    private func start() {
      subscription = actions
        .receive(on: DispatchQueue.main)
        /* Filter actions */
        .filter { [unowned self] action in
          Self.shouldIncludeAction(action, state: self.state)
        }
        /* Create async actions */
        .flatMap { [unowned self] action in
          self.createAsyncAction(with: action)
            .receive(on: DispatchQueue.main)
        }
        /* Filter actions */
        .filter { [unowned self] action in
          Self.shouldIncludeAction(action, state: self.state)
        }
        /* Side effects */
        .handleEvents(receiveOutput: { [unowned self] action in
          /* Dispatch action after action if needed */
          if let action = Self.createActionWithAction(action, state: self.state) {
            self.actions.send(action)
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

    private func createAsyncAction(with action: Action) -> AnyPublisher<Action, Never> {
      switch action {
      case .loadFirstPage:
        return actionCreator.loadFirstPage()
      case .loadNextPage:
        return actionCreator.loadNextPage(state.pagination.next)
      case let .loadHeader(totalCount):
        return actionCreator.loadHeader(totalCount: totalCount)
      default:
        return Empty<Action, Never>().eraseToAnyPublisher()
      }
    }
  }
}

extension CountryList.Store {
  static func shouldIncludeAction(
    _ action: CountryList.Action, state: CountryList.State
  ) -> Bool {
    switch action {
    /* Ignore load next if already loading or loaded all */
    case .loadNextPage:
      if state.isLoadingNextPage ||
        state.items.count >= state.pagination.totalCount {
        return false
      }
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

  static func createActionWithAction(
    _ action: CountryList.Action, state: CountryList.State
  ) -> CountryList.Action? {
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
