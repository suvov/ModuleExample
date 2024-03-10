import Foundation

extension CountryList {
  enum Adapter {
    static func adaptedCountries(
      _ countries: [CountriesResponse.Country]
    ) -> [ItemModel] {
      countries
        .map { ItemModel(id: $0.id, name: $0.name) }
    }

    static func adaptedHeader(_ countriesCount: Int, _ unCountriesCount: Int) -> String? {
      if countriesCount < unCountriesCount {
        return "There are \(unCountriesCount - countriesCount) less countries than official UN countries..."
      } else if countriesCount > unCountriesCount {
        return "There are \(countriesCount - unCountriesCount) more countries than official UN countries..."
      } else {
        return nil
      }
    }

    static func adaptedError(_ error: Error) -> String {
      let description: String
      if error.localizedDescription.isEmpty {
        description = "Unknown error"
      } else {
        description = "Error loading countries: \(error.localizedDescription)"
      }
      return description
    }
  }
}
