import Foundation

extension CountryList {
  struct State: Equatable {
    var pagination: Pagination
    var screenState: ScreenState
  }

  struct Pagination: Equatable {
    let totalCount: Int
    let currentPage: Int
  }

  enum ScreenState: Equatable {
    case empty
    case loading
    case list(ListModel)
    case error(String)
  }

  struct ListModel: Equatable {
    let header: String?
    let items: [ItemModel]
    let isLoadingNextPage: Bool
  }

  struct ItemModel: Equatable {
    let id: Int
    let name: String
  }
}

extension CountryList.State {
  static var initial: Self {
    .init(pagination: .initial, screenState: .empty)
  }
}

extension CountryList.Pagination {
  static var initial: Self {
    .init(totalCount: 0, currentPage: -1)
  }
}

// MARK: - Debug description

extension CountryList.State: CustomDebugStringConvertible {
  public var debugDescription: String {
    "State\n\(pagination)\n\(screenState)"
  }
}

extension CountryList.Pagination: CustomDebugStringConvertible {
  public var debugDescription: String {
    "currentPage: \(currentPage) totalCount: \(totalCount)"
  }
}

extension CountryList.ScreenState: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .empty:
      ".empty"
    case .loading:
      ".loading"
    case let .error(text):
      "error: \(text)"
    case let .list(model):
      """
      header: \(model.header ?? "nil"),
      .items: \(model.items.count),
      isLoadingNextPage: \(model.isLoadingNextPage)
      """
    }
  }
}

extension CountryList.ItemModel: CustomDebugStringConvertible {
  public var debugDescription: String {
    "\(id) \(name)"
  }
}
