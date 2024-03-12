import Combine
import Foundation

protocol CountryListStoreProtocol: ObservableObject {
  var state: CountryList.State { get }
  func dispatchAction(_ action: CountryList.Action)
}

extension CountryList {
  final class Store: CountryListStoreProtocol {
    private let reducer: CountryListReducerProtocol
    private var subscription: AnyCancellable?

    init(initialState: State = .initial,
         reducer: CountryListReducerProtocol) {
      self.state = initialState
      self.reducer = reducer
      start()
    }

    @Published
    private(set) var state: State

    func dispatchAction(_ action: Action) {
      actions.send(action)
    }

    private let actions = PassthroughSubject<Action, Never>()

    private func start() {
      subscription = actions
        .receive(on: DispatchQueue.main)
        .flatMap { [unowned self] action in
          self.reducer.reduce(state: &self.state, with: action)
        }
        .sink { [unowned self] action in
          self.actions.send(action)
        }
    }
  }
}
