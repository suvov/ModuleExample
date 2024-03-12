import SwiftUI
import UIKit

enum CountryList {
  static func createModule() -> UIViewController {
    let actionCreator = ActionCreator(
      countryService: CountryService(),
      unService: UNService()
    )
    let reducer = Reducer(actionCreator: actionCreator)
    let store = Store(reducer: reducer)
    let screen = Screen(store: store)
    let vc = UIHostingController(rootView: screen)
    vc.title = "Countries"
    return vc
  }
}
