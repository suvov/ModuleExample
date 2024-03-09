import XCTest
import Combine
@testable import ModuleExample

final class CountryListActionCreatorTests: XCTestCase {
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    subscriptions = []
  }
  
  func testLoadFirstPage() {
    // Given
    var countryService = CountryServiceMock()
    countryService.countriesResult = .init(
      page: 0, totalCount: 0, countries: []
    )
    let actionCreator = CountryList.ActionCreator(
      countryService: countryService
    )
    let expectedActions: [CountryList.Action] = [
      .loadFirstPage,
      .didLoadPage(.init(page: 0, totalCount: 0, items: []))
    ]
    
    var receivedActions = [CountryList.Action]()
    
    // When
    actionCreator.loadFirstPage()
      .sink { action in
        receivedActions.append(action)
      }
      .store(in: &subscriptions)
    
    // Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedActions, receivedActions)
  }
  
  func testLoadNextPage() {
    // Given
    var countryService = CountryServiceMock()
    countryService.countriesResult = .init(
      page: 1, totalCount: 0, countries: []
    )
    let actionCreator = CountryList.ActionCreator(
      countryService: countryService
    )
    let expectedActions: [CountryList.Action] = [
      .loadNextPage,
      .didLoadPage(.init(page: 1, totalCount: 0, items: []))
    ]
    
    var receivedActions = [CountryList.Action]()
    
    // When
    actionCreator.loadNextPage(1)
      .sink { action in
        receivedActions.append(action)
      }
      .store(in: &subscriptions)
    
    // Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedActions, receivedActions)
  }
}
