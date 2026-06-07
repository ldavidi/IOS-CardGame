import SwiftUI
import Combine

struct GameCard {
    let symbol: String
    let value: Int
}

struct GameView: View {
    
    let playerName: String
    let playerSide: String
    let backToMenu: () -> Void
    
    @State private var playerScore = 0
    @State private var pcScore = 0
    
    @State private var round = 0
    @State private var secondsLeft = 5
    
    @State private var playerCard = GameCard(symbol: "A♠️", value: 14)
    @State private var pcCard = GameCard(symbol: "K♥️", value: 13)
    
    @State private var showCards = false
    @State private var gameOver = false
    
    let cards = [
        GameCard(symbol: "2♣️", value: 2),
        GameCard(symbol: "3♦️", value: 3),
        GameCard(symbol: "4♠️", value: 4),
        GameCard(symbol: "5♥️", value: 5),
        GameCard(symbol: "6♣️", value: 6),
        GameCard(symbol: "7♦️", value: 7),
        GameCard(symbol: "8♠️", value: 8),
        GameCard(symbol: "9♥️", value: 9),
        GameCard(symbol: "10♣️", value: 10),
        GameCard(symbol: "J♦️", value: 11),
        GameCard(symbol: "Q♠️", value: 12),
        GameCard(symbol: "K♥️", value: 13),
        GameCard(symbol: "A♠️", value: 14)
    ]
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        
        if gameOver {
            
            ResultView(
                winner: winnerName(),
                score: winnerScore(),
                backToMenu: backToMenu
            )
            
        } else {
            
            VStack(spacing: 25) {
                
                scoreHeader
                
                HStack(spacing: 35) {
                    
                    if playerSide == "West Side" {
                        cardView(playerCard)
                        timerView
                        cardView(pcCard)
                    } else {
                        cardView(pcCard)
                        timerView
                        cardView(playerCard)
                    }
                }
                
                Text("Round \(round) / 10")
                    .font(.headline)
            }
            .padding()
            .onAppear {
                if round == 0 {
                    startRound()
                }
            }
            .onReceive(timer) { _ in
                
                guard !gameOver else { return }
                
                if secondsLeft > 1 {
                    
                    secondsLeft -= 1
                    
                    if secondsLeft == 3 {
                        showCards = true
                        updateScore()
                    }
                    
                } else {
                    
                    if round >= 10 {
                        gameOver = true
                    } else {
                        startRound()
                    }
                }
            }
        }
    }
    
    var scoreHeader: some View {
        
        HStack {
            
            if playerSide == "West Side" {
                
                scoreView(
                    name: playerName,
                    score: playerScore
                )
                
                Spacer()
                
                scoreView(
                    name: "PC",
                    score: pcScore
                )
                
            } else {
                
                scoreView(
                    name: "PC",
                    score: pcScore
                )
                
                Spacer()
                
                scoreView(
                    name: playerName,
                    score: playerScore
                )
            }
        }
        .padding(.horizontal, 40)
    }
    
    var timerView: some View {
        
        VStack {
            
            Image(systemName: "timer")
                .font(.largeTitle)
            
            Text("\(secondsLeft)")
                .font(.largeTitle)
                .bold()
        }
    }
    
    func scoreView(name: String, score: Int) -> some View {
        
        VStack {
            
            Text(name)
                .font(.headline)
            
            Text("\(score)")
                .font(.largeTitle)
                .bold()
        }
    }
    
    func cardView(_ card: GameCard) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.90, green: 0.94, blue: 0.97))
                .frame(width: 120, height: 170)
                .shadow(radius: 4)
            
            if showCards {
                ZStack {
                    Text(card.symbol)
                        .font(.system(size: 58))
                        .bold()
                    
                    Text(card.symbol.prefix(1))
                        .font(.system(size: 42))
                        .bold()
                        .foregroundStyle(.red)
                        .position(x: 32, y: 35)
                }
            } else {
                ZStack {
                    diagonalStripes()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(width: 100, height: 145)
                    
                    Image(systemName: "suit.club.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.black)
                }
            }
        }
    }
    func diagonalStripes() -> some View {
        ZStack {
            Color.white.opacity(0.4)
            
            ForEach(-6...8, id: \.self) { i in
                Rectangle()
                    .fill(Color.red.opacity(0.45))
                    .frame(width: 8, height: 220)
                    .rotationEffect(.degrees(45))
                    .offset(x: CGFloat(i * 22))
            }
        }
    }
    
    func startRound() {
        
        playerCard = cards.randomElement()!
        pcCard = cards.randomElement()!
        
        round += 1
        secondsLeft = 5
        
        showCards = false
    }
    
    func updateScore() {
        
        if playerCard.value > pcCard.value {
            playerScore += 1
        }
        else if pcCard.value > playerCard.value {
            pcScore += 1
        }
    }
    
    func winnerName() -> String {
        
        if playerScore > pcScore {
            return playerName
        }
        
        return "PC"
    }
    
    func winnerScore() -> Int {
        max(playerScore, pcScore)
    }
}
