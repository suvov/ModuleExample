import Combine
import Foundation

protocol CountryListReducerProtocol {
  func reduce(
    state: inout CountryList.State,
    with action: CountryList.Action
  ) -> AnyPublisher<CountryList.Action, Never>
}

extension CountryList {
  final class Reducer: CountryListReducerProtocol {
    private let actionCreator: CountryListActionCreatorProtocol

    init(actionCreator: CountryListActionCreatorProtocol) {
      self.actionCreator = actionCreator
    }

    func reduce(
      state: inout CountryList.State,
      with action: CountryList.Action
    ) -> AnyPublisher<CountryList.Action, Never> {
      switch action {
      case .loadFirstPage:
        state.pagination = .initial
        state.screenState = .loading
        return actionCreator.loadFirstPage()
      case .loadNextPage:
        /* Ignore load next if already loading or loaded all */
        if state.isLoadingNextPage ||
          state.items.count >= state.pagination.totalCount {
          return empty
        }
        state.screenState = .list(CountryList.ListModel(
          header: state.header,
          items: state.items,
          isLoadingNextPage: true
        ))
        return actionCreator.loadNextPage(state.pagination.next)
      case let .didLoadPage(pageInfo):
        /* Ignore loaded page if it's not the one expected. Might happen after reload */
        if pageInfo.page != state.pagination.next {
          return empty
        }
        state.pagination = CountryList.Pagination(
          totalCount: pageInfo.totalCount,
          currentPage: pageInfo.page
        )
        state.screenState = .list(CountryList.ListModel(
          header: state.header,
          items: state.items + pageInfo.items,
          isLoadingNextPage: false
        ))
        if state.header == nil {
          return Just(.loadHeader(pageInfo.totalCount)).eraseToAnyPublisher()
        } else {
          return empty
        }
      case let .loadHeader(totalCount):
        return actionCreator.loadHeader(totalCount: totalCount)
      case let .didLoadHeader(header):
        /* Ignore loaded header if loading whole screen. Might happen after reload. */
        if state.screenState == .loading {
          return empty
        }
        state.screenState = .list(CountryList.ListModel(
          header: header,
          items: state.items,
          isLoadingNextPage: state.isLoadingNextPage
        ))
        return empty
      case let .error(text):
        state.pagination = .initial
        state.screenState = .error(text)
        return empty
      }
    }

    private var empty: AnyPublisher<Action, Never> {
      Empty<Action, Never>().eraseToAnyPublisher()
    }
  }
}

// MARK: Helper

private extension CountryList.State {
  var items: [CountryList.ItemModel] {
    switch screenState {
    case let .list(model):
      return model.items
    default:
      return []
    }
  }

  var isLoadingNextPage: Bool {
    switch screenState {
    case let .list(model):
      return model.isLoadingNextPage
    default:
      return false
    }
  }

  var header: String? {
    switch screenState {
    case let .list(model):
      return model.header
    default:
      return nil
    }
  }
}

private extension CountryList.Pagination {
  var next: Int {
    currentPage + 1
  }
}
