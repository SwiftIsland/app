import SwiftUI
import Defaults

struct Hint: Hashable {
    let text: String = "Why don't you take **hint**"
}

struct HintView: View {
    let hint: Hint
    var body: some View {
        let text: LocalizedStringKey = LocalizedStringKey(hint.text)
        Text(text)
    }
}
