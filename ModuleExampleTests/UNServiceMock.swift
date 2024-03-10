import Combine
import Foundation
@testable import ModuleExample

struct UNServiceMock: UNServiceProtocol {
  var countResult: Int?
  
  func getUNCountriesCount() -> AnyPublisher<Int, Error> {
    if let countResult {
      return Just(countResult)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<Int, Error>().eraseToAnyPublisher()
  }
}
