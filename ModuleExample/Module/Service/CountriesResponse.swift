struct CountriesResponse {
  let page: Int
  let totalCount: Int
  let countries: [Country]

  struct Country: Decodable {
    let id: Int
    let name: String
  }
}
