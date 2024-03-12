import Foundation

extension CountryList {
  enum Action: Equatable {
    case loadFirstPage
    case loadNextPage
    case didLoadPage(PageInfo)
    case loadHeader(Int)
    case didLoadHeader(String?)
    case error(String)
  }

  struct PageInfo: Equatable {
    let page: Int
    let totalCount: Int
    let items: [ItemModel]
  }
}

// MARK: - Debug description

extension CountryList.Action: CustomDebugStringConvertible {
  public var debugDescription: String {
    let description: String
    switch self {
    case .loadFirstPage:
      description = "loadFirstPage"
    case .loadNextPage:
      description = "loadNextPage"
    case let .didLoadPage(pageInfo):
      description = "didLoadPage \(pageInfo)"
    case .loadHeader:
      description = "loadHeader"
    case .didLoadHeader:
      description = "didLoadHeader"
    case .error:
      description = "error"
    }
    return "Action \(description)"
  }
}

extension CountryList.PageInfo: CustomDebugStringConvertible {
  public var debugDescription: String {
    "page: \(page), totalCount: \(totalCount), items: \(items.count)"
  }
}
