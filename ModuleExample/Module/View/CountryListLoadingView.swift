import SwiftUI

struct CountryListLoadingView: View {
  var body: some View {
    CountryListView(model: .placeholder,
                    onEvent: { _ in })
      .redacted(reason: .placeholder)
      .disabled(true)
  }
}

extension CountryList.ListModel {
  static var placeholder: Self {
    let items = (0 ... 6).map {
      CountryList.ItemModel(id: $0, name: "Placeholder")
    }
    return CountryList.ListModel(
      header: nil,
      items: items,
      isLoadingNextPage: false
    )
  }
}

// MARK: - Preview

#if DEBUG
  #Preview {
    CountryListLoadingView()
  }
#endif
