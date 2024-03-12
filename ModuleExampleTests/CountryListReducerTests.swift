import Combine
import XCTest
@testable import ModuleExample

final class CountryListReducerTests: XCTestCase {
  private var subscriptions = Set<AnyCancellable>()
  
  override func setUp() {
    subscriptions = []
  }
  
  func testLoadFirstPage() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let didLoadPageAction = CountryList.Action.didLoadPage(
      .init(page: 0, totalCount: 0, items: [])
    )
    actionCreator.loadFirstPageResult = didLoadPageAction
    let reducer = CountryList.Reducer(actionCreator: actionCreator)
    var state = CountryList.State.initial
    
    let expectedState = CountryList.State(
      pagination: .initial, screenState: .loading
    )
    
    let expectedActions = [didLoadPageAction]
    
    var actions = [CountryList.Action]()

    // When
    reducer.reduce(state: &state, with: .loadFirstPage).sink { action in
      actions.append(action)
    }
    .store(in: &subscriptions)
    
    //Then
    XCTAssertEqual(expectedState, state)
    XCTAssertEqual(expectedActions, actions)
  }
  
  func testLoadNextPage() {
    // Given
    var actionCreator = CountryListActionCreatorMock()
    let didLoadPageAction = CountryList.Action.didLoadPage(
      .init(page: 1, totalCount: 2, items: [])
    )
    actionCreator.loadNextPageResult = didLoadPageAction
    let reducer = CountryList.Reducer(actionCreator: actionCreator)
    var state = CountryList.State(
      pagination: .init(totalCount: 2, currentPage: 0), 
      screenState: .list(.init(header: nil, items: [], isLoadingNextPage: false))
    )
    
    let expectedState = CountryList.State(
      pagination: state.pagination, 
      screenState: .list(.init(header: nil, items: [], isLoadingNextPage: true))
    )
    
    let expectedActions = [didLoadPageAction]
    
    var actions = [CountryList.Action]()

    // When
    reducer.reduce(state: &state, with: .loadNextPage).sink { action in
      actions.append(action)
    }
    .store(in: &subscriptions)
    
    //Then
    XCTAssertEqual(expectedState, state)
    XCTAssertEqual(expectedActions, actions)
  }
  
  func testLoadNextPageIgnoredBecauseAlreadyLoading() {
    // Given
    let actionCreator = CountryListActionCreatorMock()
    let reducer = CountryList.Reducer(actionCreator: actionCreator)
    var state = CountryList.State(
      pagination: .init(totalCount: 2, currentPage: 0),
      screenState: .list(.init(header: nil, items: [], isLoadingNextPage: true))
    )
    
    let expectedState = state
    
    let expectedActions: [CountryList.Action] = []
    
    var actions = [CountryList.Action]()

    // When
    reducer.reduce(state: &state, with: .loadNextPage).sink { action in
      actions.append(action)
    }
    .store(in: &subscriptions)
    
    //Then
    XCTAssertEqual(expectedState, state)
    XCTAssertEqual(expectedActions, actions)
  }
  
  func testLoadNextPageIgnoredBecauseLoadedAll() {
    // Given
    let actionCreator = CountryListActionCreatorMock()
    let reducer = CountryList.Reducer(actionCreator: actionCreator)
    var state = CountryList.State(
      pagination: .init(totalCount: 0, currentPage: 0),
      screenState: .list(.init(header: nil, items: [], isLoadingNextPage: false))
    )
    
    let expectedState = state
    
    let expectedActions: [CountryList.Action] = []
    
    var actions = [CountryList.Action]()

    // When
    reducer.reduce(state: &state, with: .loadNextPage).sink { action in
      actions.append(action)
    }
    .store(in: &subscriptions)
    
    //Then
    XCTAssertEqual(expectedState, state)
    XCTAssertEqual(expectedActions, actions)
  }
}
