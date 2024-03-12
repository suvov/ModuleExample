import Combine
import Foundation
@testable import ModuleExample

struct CountryListActionCreatorMock: CountryListActionCreatorProtocol {
  var loadFirstPageResult: CountryList.Action?
  var loadNextPageResult: CountryList.Action?
  var loadHeaderResult: CountryList.Action?
  
  func loadFirstPage() -> AnyPublisher<CountryList.Action, Never> {
    if let loadFirstPageResult {
      return Just(loadFirstPageResult)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountryList.Action, Never>().eraseToAnyPublisher()
  }
  
  func loadNextPage(_ page: Int) -> AnyPublisher<CountryList.Action, Never> {
    if let loadNextPageResult {
      return Just(loadNextPageResult)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountryList.Action, Never>().eraseToAnyPublisher()
  }
  
  func loadHeader(totalCount: Int) -> AnyPublisher<CountryList.Action, Never> {
    if let loadHeaderResult {
      return Just(loadHeaderResult)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountryList.Action, Never>().eraseToAnyPublisher()
  }
}
