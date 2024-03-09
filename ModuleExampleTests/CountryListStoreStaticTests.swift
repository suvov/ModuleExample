import XCTest
import Combine
@testable import ModuleExample

final class CountryListStoreStaticTests: XCTestCase {
  
  func testExcludesLoadNextEventIfAlreadyLoading() {
    // Given
    let state = CountryList.State.initial.reduced(with: .loadNextPage)
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeEvent(.loadNext, state: state)
    
    // Then
    XCTAssertFalse(shouldInclude)
  }
  
  func testExcludesLoadNextEventIfLoadedAll() {
    // Given
    let state = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 1, items: [.init(id: 0, name: "")]))
    )
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeEvent(
      .loadNext, state: state
    )
    
    // Then
    XCTAssertFalse(shouldInclude)
  }
  
  func testExcludesDidLoadPageActionIfLoadedPageThatWasntExpected() {
    // Given
    let state = CountryList.State.initial
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeAction(
      .didLoadPage(.init(page: 1, totalCount: 1, items: [])), state: state)
    
    // Then
    XCTAssertFalse(shouldInclude)
  }
}
