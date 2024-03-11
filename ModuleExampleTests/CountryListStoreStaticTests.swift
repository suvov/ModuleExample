import XCTest
import Combine
@testable import ModuleExample

final class CountryListStoreStaticTests: XCTestCase {
  
  func testExcludesLoadNextActionIfAlreadyLoading() {
    // Given
    let state = CountryList.State.initial.reduced(with: .loadNextPage)
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeAction(
      .loadNextPage, state: state
    )
    
    // Then
    XCTAssertFalse(shouldInclude)
  }
  
  func testExcludesLoadNextActionIfLoadedAll() {
    // Given
    let state = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 1, items: [.init(id: 0, name: "")]))
    )
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeAction(
      .loadNextPage, state: state
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

  func testExcludesDidLoadHeaderActionIfLoadingWholeScreen() {
    // Given
    let state = CountryList.State.initial.reduced(with: .loadFirstPage)
    
    // When
    let shouldInclude = CountryList.Store.shouldIncludeAction(
      .didLoadHeader(""), state: state
    )
    
    // Then
    XCTAssertFalse(shouldInclude)
  }
  
  func testCreatesLoadHeaderActionAfterDidLoadPageActionIfNoHeader() {
    // Given
    let state = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 1, items: []))
    )
    let expected = CountryList.Action.loadHeader(1)
    
    // When
    let action = CountryList.Store.createActionWithAction(
      .didLoadPage(.init(page: 0, totalCount: 1, items: [])), state: state
    )
    
    // Then
    XCTAssertEqual(expected, action)
  }
  
  func testDoesntCreateLoadHeaderActionAfterDidLoadPageActionIfHeaderPresent() {
    // Given
    let state = CountryList.State.initial
      .reduced(with: .didLoadPage(.init(page: 0, totalCount: 1, items: [])))
      .reduced(with: .didLoadHeader(""))
        
    // When
    let action = CountryList.Store.createActionWithAction(
      .didLoadPage(.init(page: 0, totalCount: 1, items: [])), state: state
    )
    
    // Then
    XCTAssertNil(action)
  }
}
