import Combine

protocol CountryListActionCreatorProtocol {
  func loadFirstPage() -> AnyPublisher<CountryList.Action, Never>
  func loadNextPage(_ page: Int) -> AnyPublisher<CountryList.Action, Never>
  func loadHeader(totalCount: Int) -> AnyPublisher<CountryList.Action, Never>
}

extension CountryList {
  final class ActionCreator: CountryListActionCreatorProtocol {
    private let countryService: CountryServiceProtocol
    private let unService: UNServiceProtocol

    init(countryService: CountryServiceProtocol,
         unService: UNServiceProtocol) {
      self.countryService = countryService
      self.unService = unService
    }

    func loadFirstPage() -> AnyPublisher<Action, Never> {
      loadCountries(page: 0)
        .eraseToAnyPublisher()
    }

    func loadNextPage(_ page: Int) -> AnyPublisher<Action, Never> {
      loadCountries(page: page)
        .eraseToAnyPublisher()
    }

    func loadHeader(totalCount: Int) -> AnyPublisher<Action, Never> {
      unService.getUNCountriesCount()
        .map { unCountriesCount in
          let header = Adapter.adaptedHeader(totalCount, unCountriesCount)
          return Action.didLoadHeader(header)
        }
        .catch { error in
          Just(Action.error(Adapter.adaptedError(error)))
        }
        .eraseToAnyPublisher()
    }

    private func loadCountries(page: Int) -> AnyPublisher<Action, Never> {
      countryService
        .getCountries(page: page)
        .map {
          .didLoadPage(
            PageInfo(
              page: $0.page,
              totalCount: $0.totalCount,
              items: Adapter.adaptedCountries($0.countries)
            )
          )
        }
        .catch { error in
          Just(Action.error(Adapter.adaptedError(error)))
        }
        .eraseToAnyPublisher()
    }
  }
}
