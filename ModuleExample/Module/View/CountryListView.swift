import SwiftUI

struct CountryListView: View {
  let model: CountryList.ListModel
  let onEvent: (CountryList.Event) -> Void

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 8) {
        if let header = model.header {
          Text(header)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .font(.subheadline)
        }
        ForEach(model.items, id: \.id) { item in
          CountryListItemView(model: item)
            .frame(minHeight: 44)
            .onAppear {
              if item == model.items.last {
                onEvent(.loadNext)
              }
            }
        }
        if model.isLoadingNextPage {
          CountryListItemView(model: .nextPlaceholder)
            .redacted(reason: .placeholder)
        }
      }
      .multilineTextAlignment(.leading)
      .padding(.horizontal, 16)
      .toolbar {
        Button("Reload",
               systemImage: "arrow.clockwise") {
          onEvent(.loadFirst)
        }
        .tint(.primary)
        .unredacted()
      }
    }
  }
}

private extension CountryList.ItemModel {
  static var nextPlaceholder: Self {
    .init(id: Int.min, name: "Placeholder")
  }
}

// MARK: - Preview & Stubs

#if DEBUG
  #Preview("Loaded") {
    CountryListView(model: .stub, onEvent: { _ in })
  }

  #Preview("Header") {
    CountryListView(model: .stubHeader, onEvent: { _ in })
  }

  #Preview("Loading next") {
    CountryListView(model: .stubLoadingNext, onEvent: { _ in })
  }

  extension CountryList.ListModel {
    static var stub: Self {
      .init(header: nil,
            items: (0 ... 10).map { .stub($0) },
            isLoadingNextPage: false)
    }

    static var stubHeader: Self {
      .init(header: "Header",
            items: (0 ... 10).map { .stub($0) },
            isLoadingNextPage: false)
    }

    static var stubLoadingNext: Self {
      .init(header: nil,
            items: (0 ... 10).map { .stub($0) },
            isLoadingNextPage: true)
    }
  }
#endif
