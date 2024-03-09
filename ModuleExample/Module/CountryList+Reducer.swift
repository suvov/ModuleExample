import Foundation

extension CountryList.State {
  func reduced(with action: CountryList.Action) -> Self {
    switch action {
    case .loadFirstPage:
      return .init(
        pagination: .initial,
        screenState: .loading
      )
    case .loadNextPage:
      let listModel = CountryList.ListModel(
        items: items,
        isLoadingNextPage: true
      )
      return .init(
        pagination: pagination,
        screenState: .list(listModel)
      )
    case let .didLoadPage(pageInfo):
      let listModel = CountryList.ListModel(
        items: items + pageInfo.items,
        isLoadingNextPage: false
      )
      let pagination = CountryList.Pagination(
        totalCount: pageInfo.totalCount,
        currentPage: pageInfo.page
      )
      return .init(
        pagination: pagination,
        screenState: .list(listModel)
      )
    case let .error(errorText):
      return .init(pagination: .initial, screenState: .error(errorText))
    }
  }
}
