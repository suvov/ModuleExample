import SwiftUI

struct CountryListErrorView: View {
  let description: String
  let onAction: (CountryList.Action) -> Void

  var body: some View {
    Text(description)
      .foregroundStyle(.secondary)
      .toolbar {
        Button("Reload",
               systemImage: "arrow.clockwise") {
          onAction(.loadFirstPage)
        }
        .tint(.primary)
      }
  }
}

// MARK: - Preview & stubs

#if DEBUG
  #Preview {
    CountryListErrorView(description: "Error...", onAction: { _ in })
  }
#endif
