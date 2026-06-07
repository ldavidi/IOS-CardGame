import SwiftUI
import CoreLocation

enum Screen {
    case start
    case game
}

struct ContentView: View {
    
    @AppStorage("playerName") var playerName = ""
    
    @State private var tempName = ""
    @State private var screen: Screen = .start
    @State private var playerSide = ""
    
    @StateObject private var locationManager = LocationManager()
    
    let middleLongitude = 34.817549168324334
    
    var body: some View {
        if screen == .start {
            startView
                .onAppear {
                    locationManager.requestLocation()
                }
        } else {
            GameView(playerName: playerName, playerSide: playerSide) {
                screen = .start
            }
        }
    }
    
    var startView: some View {
        VStack(spacing: 22) {
            
            Button("Insert name") {
                playerName = ""
                tempName = ""
            }
            .font(.headline)
            
            if playerName.isEmpty {
                TextField("Enter your name", text: $tempName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 260)
                
                Button("Save Name") {
                    playerName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                .buttonStyle(.borderedProminent)
                .disabled(tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            } else {
                Text("Hi \(playerName)")
                    .font(.largeTitle)
                    .bold()
            }
            
            HStack(spacing: 80) {
                sideView(title: "West Side", isSelected: playerSide == "West Side")
                
                sideView(title: "East Side", isSelected: playerSide == "East Side")
            }
            
            if playerSide.isEmpty {
                Text("Getting location...")
                    .foregroundStyle(.secondary)
            } else {
                Text("Your side: \(playerSide)")
                    .font(.headline)
            }
            
            Button("START") {
                screen = .game
            }
            .font(.title2)
            .frame(width: 180, height: 55)
            .buttonStyle(.borderedProminent)
            .disabled(playerName.isEmpty || playerSide.isEmpty)
        }
        .padding()
        .onChange(of: locationManager.location) { _, newLocation in
            if let newLocation {
                playerSide = sideText(newLocation.coordinate.longitude)
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func sideView(title: String, isSelected: Bool) -> some View {
        VStack {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 110, height: 110)
                
                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 85))
                    .foregroundStyle(.green.opacity(0.85))
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 60, height: 120)
                    .offset(x: title == "West Side" ? 55 : -55)
            }
            .opacity(isSelected ? 1.0 : 0.6)
            
            Text(title)
                .font(.headline)
        }
    }
    
    func sideText(_ longitude: Double) -> String {
        longitude > middleLongitude ? "East Side" : "West Side"
    }
}
