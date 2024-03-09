import Combine
import Foundation
@testable import ModuleExample

struct CountryServiceMock: CountryServiceProtocol {
  var countriesResult: CountriesResponse?
  
  func getCountries(page: Int) -> AnyPublisher<CountriesResponse, Error> {
    if let countriesResult {
      return Just(countriesResult)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    assertionFailure("\(#function) called, but no result set up")
    return Empty<CountriesResponse, Error>().eraseToAnyPublisher()
  }
}
