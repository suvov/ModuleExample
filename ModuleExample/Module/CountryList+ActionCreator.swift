import Combine

protocol CountryListActionCreatorProtocol {
  func loadFirstPage() -> AnyPublisher<CountryList.Action, Never>
  func loadNextPage(_ page: Int) -> AnyPublisher<CountryList.Action, Never>
}

extension CountryList {
  final class ActionCreator: CountryListActionCreatorProtocol {
    private let countryService: CountryServiceProtocol

    init(countryService: CountryServiceProtocol) {
      self.countryService = countryService
    }

    func loadFirstPage() -> AnyPublisher<Action, Never> {
      loadCountries(page: 0)
        .prepend(.loadFirstPage)
        .eraseToAnyPublisher()
    }

    func loadNextPage(_ page: Int) -> AnyPublisher<Action, Never> {
      loadCountries(page: page)
        .prepend(.loadNextPage)
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
