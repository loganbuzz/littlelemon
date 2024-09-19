import SwiftUI

struct EmptyStateView: View {
    let message: String
    let systemImageName: String
    let resetAction: (() -> Void)?
    let suggestAction: (() -> Void)?

    init(
        message: String,
        systemImageName: String = "magnifyingglass.circle",
        resetAction: (() -> Void)? = nil,
        suggestAction: (() -> Void)? = nil
    ) {
        self.message = message
        self.systemImageName = systemImageName
        self.resetAction = resetAction
        self.suggestAction = suggestAction
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)

            Text(message)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            // Display Reset Button if resetAction is provided
            if let resetAction = resetAction {
                Button(action: resetAction) {
                    Text("Clear Search")
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }

            // Display Suggestion Button if suggestAction is provided
            if let suggestAction = suggestAction {
                Button(action: suggestAction) {
                    Text("View Popular Dishes")
                        .font(.headline)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(
            message: "No dishes found matching your search.",
            resetAction: {
                print("Clear Search tapped")
            },
            suggestAction: {
                print("View Popular Dishes tapped")
            }
        )
    }
}
