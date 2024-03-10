extension CountryList {
  enum Event: Equatable {
    case loadFirst
    case loadNext
    case loadHeader(Int)
  }
}

// MARK: - Debug description

extension CountryList.Event: CustomDebugStringConvertible {
  public var debugDescription: String {
    let description: String
    switch self {
    case .loadFirst:
      description = "loadFirst"
    case .loadNext:
      description = "loadNext"
    case .loadHeader:
      description = "loadHeader"
    }
    return "Event \(description)"
  }
}
