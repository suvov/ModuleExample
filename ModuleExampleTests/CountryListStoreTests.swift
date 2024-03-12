import XCTest
import Combine
@testable import ModuleExample

final class CountryListStoreTests: XCTestCase {
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    subscriptions = []
  }
  
  func testLoadsFirstPageAndHeader() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let didLoadPageAction = CountryList.Action.didLoadPage(
      .init(page: 0, totalCount: 0, items: [])
    )
    actionCreator.loadFirstPageResult = didLoadPageAction
    
    let didLoadHeaderAction = CountryList.Action.didLoadHeader("")
    actionCreator.loadHeaderResult = didLoadHeaderAction
    
    let reducer = CountryList.Reducer(actionCreator: actionCreator)
    let initialState = CountryList.State.initial
    var loadingState = initialState
    _ = reducer.reduce(state: &loadingState, with: .loadFirstPage)
    var didLoadFirstState = loadingState
    _ = reducer.reduce(state: &didLoadFirstState, with: didLoadPageAction)
    var didLoadHeaderState = didLoadFirstState
    _ = reducer.reduce(state: &didLoadHeaderState, with: didLoadHeaderAction)
    
    let expectedStates: [CountryList.State] = [
      initialState,
      loadingState,
      didLoadFirstState,
      didLoadFirstState,
      didLoadHeaderState
    ]
    var receivedStates = [CountryList.State]()
    
    let store = CountryList.Store(
      initialState: initialState,
      reducer: reducer
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
