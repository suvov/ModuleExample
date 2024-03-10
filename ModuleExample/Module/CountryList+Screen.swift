import SwiftUI

extension CountryList {
  struct Screen<Store: CountryListStoreProtocol>: View {
    @ObservedObject
    var store: Store

    var body: some View {
      Group {
        switch store.state.screenState {
        case .empty:
          EmptyView()
        case .loading:
          CountryListLoadingView()
        case let .list(model):
          CountryListView(model: model, onEvent: store.onEvent)
        case let .error(description):
          CountryListErrorView(description: description, onEvent: store.onEvent)
        }
      }
      .onAppear {
        store.onEvent(.loadFirst)
      }
    }
  }
}

// MARK: - Preview & Stubs

#if DEBUG
  #Preview("Loading") {
    CountryList.Screen(store: CountryListViewModelStub(.loading))
  }

  #Preview("Loaded") {
    CountryList.Screen(store: CountryListViewModelStub(.list(.stub)))
  }

  #Preview("Error") {
    CountryList.Screen(store: CountryListViewModelStub(.error("Error...")))
  }

  final class CountryListViewModelStub: CountryListStoreProtocol {
    init(_ screenState: CountryList.ScreenState) {
      self.state = CountryList.State(
        pagination: .initial,
        screenState: screenState
      )
    }

    let state: CountryList.State
    func onEvent(_ event: CountryList.Event) {}
  }
#endif
