import XCTest
import Combine
@testable import ModuleExample

final class CountryListStoreTests: XCTestCase {
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    subscriptions = []
  }
  
  func testStartsLoadingLoadsFirstPageLoadsHeaderWhenLoadFirst() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let firstPage = 0
    let totalCount = 0
    actionCreator.loadFirstPageResult = .didLoadPage(
      .init(page: firstPage, totalCount: totalCount, items: [])
    )
    let header = "Header"
    actionCreator.loadHeaderResult = .didLoadHeader(header)
    
    // Expected states
    let initial = CountryList.State.initial
    let loadingFirst = initial.reduced(with: .loadFirstPage)
    let loadedFirst = loadingFirst.reduced(with:
        .didLoadPage(.init(page: firstPage, totalCount: totalCount, items: []))
    )
    let loadedHeader = loadedFirst.reduced(with: .didLoadHeader(header))
    
    let store = CountryList.Store(
      initialState: initial, actionCreator: actionCreator
    )
    
    let expectedStates = [
      initial, loadingFirst, loadedFirst, loadedHeader
    ]
    
    var receivedStates = [CountryList.State]()
    
    store.$state
      .sink{ state in
        receivedStates.append(state)
      }
      .store(in: &subscriptions)
    
    // When
    store.dispatchAction(.loadFirstPage)
    
    //Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedStates, receivedStates)
  }
  
  func testStartsLoadingNextWhenLoadNext() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let firstPage = 0
    let nextPage = 1
    let totalCount = 2
    actionCreator.loadNextPageResult = .didLoadPage(
      .init(page: nextPage, totalCount: totalCount, items: [])
    )
    actionCreator.loadHeaderResult = .didLoadHeader("")
    
    // Expected states
    let loadedFirst = CountryList.State.initial.reduced(
      with: .didLoadPage(
        .init(page: firstPage,
              totalCount: totalCount,
              items: [.init(id: 1, name: "")])
      )
    )
    let loadingNext = loadedFirst.reduced(with: .loadNextPage)
    let loadedNext = loadingNext.reduced(
      with: .didLoadPage(.init(page: nextPage, totalCount: totalCount, items: []))
    )
    let loadedHeader = loadedNext.reduced(with: .didLoadHeader(""))
    
    let store = CountryList.Store(
      initialState: loadedFirst, actionCreator: actionCreator
    )
    
    let expectedStates = [loadedFirst, loadingNext, loadedNext, loadedHeader]
    
    var receivedStates = [CountryList.State]()
    
    store.$state
      .sink{ state in
        receivedStates.append(state)
      }
      .store(in: &subscriptions)
    
    // When
    store.dispatchAction(.loadNextPage)
    
    //Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedStates, receivedStates)
  }
  
  func testDoesntStartLoadingNextWhenLoadedAll() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let firstPage = 0
    let nextPage = 1
    let totalCount = 1
    actionCreator.loadNextPageResult = .didLoadPage(.init(page: nextPage, totalCount: totalCount, items: []))
    
    let loadedFirst = CountryList.State.initial.reduced(
      with: .didLoadPage(.init(page: firstPage, totalCount: totalCount, items: [.init(id: 0, name: "")]))
    )
    
    let store = CountryList.Store(
      initialState: loadedFirst, actionCreator: actionCreator
    )
    
    let expectedStates = [loadedFirst]
    
    var receivedStates = [CountryList.State]()
    
    store.$state
      .sink{ state in
        receivedStates.append(state)
      }
      .store(in: &subscriptions)
    
    // When
    store.dispatchAction(.loadNextPage)
    
    //Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedStates, receivedStates)
  }
  
  func testDoesntStartLoadingNextWhenAlreadyLoading() {
    // Given
    let actionCreator = CountryListActionCreatorMock()
    
    let loadingNext = CountryList.State.initial.reduced(with: .loadNextPage)
    
    let store = CountryList.Store(
      initialState: loadingNext, actionCreator: actionCreator
    )
    
    let expectedStates = [loadingNext]
    
    var receivedStates = [CountryList.State]()
    
    store.$state
      .sink{ state in
        receivedStates.append(state)
      }
      .store(in: &subscriptions)
    
    // When
    store.dispatchAction(.loadNextPage)
    
    //Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedStates, receivedStates)
  }
  
  func testReloadsWhenLoadingNext() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    actionCreator.loadFirstPageResult = .didLoadPage(.init(page: 0, totalCount: 1, items: []))
    actionCreator.loadHeaderResult = .didLoadHeader("")
    
    // Expected states
    let loadingNext = CountryList.State.initial.reduced(with: .loadNextPage)
    let loadingFirst = loadingNext.reduced(with: .loadFirstPage)
    let loadedFirst = loadingFirst.reduced(
      with: .didLoadPage(.init(page: 0, totalCount: 1, items: []))
    )
    let loadedHeader = loadedFirst.reduced(with: .didLoadHeader(""))
    let expectedStates = [loadingNext, loadingFirst, loadedFirst, loadedHeader]
    
    var receivedStates = [CountryList.State]()
    
    let store = CountryList.Store(
      initialState: loadingNext, actionCreator: actionCreator
    )
    
    store.$state
      .sink{ state in
        receivedStates.append(state)
      }
      .store(in: &subscriptions)
    
    // When
    store.dispatchAction(.loadFirstPage)
    
    //Then
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(expectedStates, receivedStates)
  }
}
