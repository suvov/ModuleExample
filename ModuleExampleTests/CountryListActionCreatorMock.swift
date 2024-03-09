import Combine
import Foundation
@testable import ModuleExample

struct CountryListActionCreatorMock: CountryListActionCreatorProtocol {
  var loadFirstPageResult: CountryList.Action?
  var loadNextPageResult: CountryList.Action?
  
  private let scheduler = DispatchQueue(label: "service-queue")
  
  func loadFirstPage() -> AnyPublisher<CountryList.Action, Never> {
    if let loadFirstPageResult {
      return Just(loadFirstPageResult)
        .prepend(.loadFirstPage)
        .delay(for: .milliseconds(1), scheduler: scheduler)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountryList.Action, Never>().eraseToAnyPublisher()
  }
  
  func loadNextPage(_ page: Int) -> AnyPublisher<CountryList.Action, Never> {
    if let loadNextPageResult {
      return Just(loadNextPageResult)
        .prepend(.loadNextPage)
        .delay(for: .milliseconds(1), scheduler: scheduler)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountryList.Action, Never>().eraseToAnyPublisher()
  }
}
