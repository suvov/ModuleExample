import SwiftUI

struct CountryListErrorView: View {
  let description: String
  let onEvent: (CountryList.Event) -> Void

  var body: some View {
    Text(description)
      .foregroundStyle(.secondary)
      .toolbar {
        Button("Reload",
               systemImage: "arrow.clockwise") {
          onEvent(.loadFirst)
        }
        .tint(.primary)
      }
  }
}

// MARK: - Preview & stubs

#if DEBUG
  #Preview {
    CountryListErrorView(description: "Error...", onEvent: { _ in })
  }
#endif
