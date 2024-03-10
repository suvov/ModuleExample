import Combine
import Foundation

protocol UNServiceProtocol {
  func getUNCountriesCount() -> AnyPublisher<Int, Error>
}

final class UNService: UNServiceProtocol {
  private let scheduler = DispatchQueue(label: "un-service-queue")

  func getUNCountriesCount() -> AnyPublisher<Int, Error> {
    Just(193)
      .delay(for: .milliseconds(1000), scheduler: scheduler)
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
