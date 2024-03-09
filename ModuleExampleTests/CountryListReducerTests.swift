import XCTest
@testable import ModuleExample

final class CountryListReducerTests: XCTestCase {
  
  func testLoadFirstPage() {
    // Given
    let initial = CountryList.State.initial
    let expected = CountryList.State(pagination: .initial, screenState: .loading)
    
    // When
    let result = initial.reduced(with: .loadFirstPage)
    
    //Then
    XCTAssertEqual(expected, result)
  }
  
  func testLoadNextPage() {
    // Given
    let items = [CountryList.ItemModel(id: 0, name: "")]
    let loadedFirst = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 1, items: items))
    )
    let expected = CountryList.State(
      pagination: loadedFirst.pagination,
      screenState: .list(.init(items: items, isLoadingNextPage: true))
    )
    
    // When
    let result = loadedFirst.reduced(with: .loadNextPage)
    
    //Then
    XCTAssertEqual(expected, result)
  }
  
  func testDidLoadFirstPage() {
    // Given
    let items = [CountryList.ItemModel(id: 0, name: "")]
    let loadingFirst = CountryList.State.initial.reduced( with: .loadFirstPage)
    let expected = CountryList.State(
      pagination: .init(totalCount: 1, currentPage: 0),
      screenState: .list(.init(items: items, isLoadingNextPage: false))
    )
    
    // When
    let result = loadingFirst.reduced(with: .didLoadPage(.init(page: 0, totalCount: 1, items: items)))
    
    //Then
    XCTAssertEqual(expected, result)
  }
  
  func testDidLoadNextPage() {
    // Given
    let firstPageItems = [CountryList.ItemModel(id: 0, name: "")]
    let secondPageItems = [CountryList.ItemModel(id: 1, name: "")]
    let loadedFirst = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 2, items: firstPageItems))
    )
    let expected = CountryList.State(
      pagination: .init(totalCount: 2, currentPage: 1),
      screenState: .list(
        .init(items: firstPageItems + secondPageItems,
              isLoadingNextPage: false)
      )
    )
    
    // When
    let result = loadedFirst.reduced(
      with: .didLoadPage(
        .init(page: 1, totalCount: 2, items: secondPageItems)
      )
    )
    
    //Then
    XCTAssertEqual(expected, result)
  }
  
  func testError() {
    // Given
    let initial = CountryList.State.initial
    
    let expected = CountryList.State.init(
      pagination: .initial, screenState: .error("error")
    )
    
    // When
    let result = initial.reduced(with: .error("error"))
    
    //Then
    XCTAssertEqual(expected, result)
  }
}
