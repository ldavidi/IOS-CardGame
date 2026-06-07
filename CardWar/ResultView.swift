import SwiftUI

struct ResultView: View {
    
    let winner: String
    let score: Int
    let backToMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Winner: \(winner)")
                .font(.largeTitle)
                .bold()
            
            Text("score: \(score)")
                .font(.title)
            
            Button("BACK TO MENU") {
                backToMenu()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
