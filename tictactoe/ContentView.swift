import SwiftUI

struct ContentView: View {
    @StateObject private var game = Game()
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        VStack(spacing: 16) {
            header
            boardGrid
            controls
        }
        .padding(20)
        .frame(minWidth: 360, minHeight: 460)
    }
    
    private var header: some View {
        VStack(spacing: 6) {
            if let winner = game.winner {
                Text("\(winner.rawValue) wins")
                    .font(.largeTitle).bold()
            } else if game.isDraw {
                Text("Draw")
                    .font(.largeTitle).bold()
            } else {
                Text("Turn: \(game.current.rawValue)")
                    .font(.title2).bold()
            }
            HStack(spacing: 12) {
                Toggle("Play vs CPU", isOn: $game.vsCPU)
                    .toggleStyle(.switch)
                Picker("CPU plays", selection: $game.cpuPlayAs) {
                    Text("X").tag(Player.x)
                    Text("O").tag(Player.o)
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 160)
            }
            .disabled(game.winner != nil || game.isDraw == true ? true : false)
            .help("Choose CPU side before starting or after a reset.")
        }
    }
    
    private var boardGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<9, id: \.self) { idx in
                cell(at: idx)
            }
        }
        .animation(.snappy, value: game.board)
    }
    
    private func cell(at index: Int) -> some View {
        Button {
            game.play(at: index)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(.secondary, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quaternary.opacity(0.2))
                    )
                Text(game.board[index]?.rawValue ?? " ")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.5)
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(.plain)
        .disabled(game.board[index] != nil || game.winner != nil || game.isDraw)
        .contentShape(Rectangle())
        .help(game.board[index] == nil ? "Place \(game.current.rawValue)" : "Occupied")
    }
    
    private var controls: some View {
        HStack(spacing: 12) {
            Button("Reset") {
                game.reset(starting: .x)
            }
            .keyboardShortcut("r", modifiers: [.command])
            
            Button("Reset, O starts") {
                game.reset(starting: .o)
            }
            
            Spacer()
            
            Button("New Game") {
                game.reset(starting: .x)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 8)
    }
}
