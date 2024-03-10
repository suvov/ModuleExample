import SwiftUI

struct CountryListItemView: View {
  let model: CountryList.ItemModel

  var body: some View {
    HStack {
      Text(model.name)
        .foregroundColor(.primary)
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundColor(.secondary)
    }
  }
}

// MARK: - Preview & Stubs

#if DEBUG
  #Preview {
    CountryListItemView(model: .stub(0))
  }

  extension CountryList.ItemModel {
    static func stub(_ id: Int) -> Self {
      .init(id: id, name: "Item-\(id)")
    }
  }
#endif
