import Combine
import Foundation

protocol CountryServiceProtocol {
  func getCountries(page: Int) -> AnyPublisher<CountriesResponse, Error>
}

final class CountryService: CountryServiceProtocol {
  private lazy var countries: [CountriesResponse.Country] = {
    let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let countries = try! JSONDecoder()
      .decode([CountriesResponse.Country].self, from: data)
    return countries
  }()

  private let scheduler = DispatchQueue(label: "service-queue")

  private let pageSize = 25

  func getCountries(page: Int) -> AnyPublisher<CountriesResponse, Error> {
    let start = page * pageSize
    let end = min(start + pageSize, countries.count)
    let countriesPage = Array(countries[start ..< end])
    return Just(
      CountriesResponse(page: page,
                        totalCount: countries.count,
                        countries: countriesPage)
    )
    .delay(for: .milliseconds(1000), scheduler: scheduler)
    .setFailureType(to: Error.self)
    .eraseToAnyPublisher()
  }
}
