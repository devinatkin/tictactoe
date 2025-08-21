//
//  Game.swift
//  tictactoe
//
//  Created by Devin Michael Atkin on 2025-08-12.
//

import Foundation
import Combine

enum Player: String{
    case x = "X"
    case o = "O"
    
    var next: Player {self == .x ? .o : .x}
}

final class Game: ObservableObject {
    @Published var board: [Player?] = Array(repeating: nil, count:9)
    @Published var current: Player = .x
    @Published var winner: Player? = nil
    @Published var isDraw: Bool = false
    
    // Simple CPU
    @Published var vsCPU: Bool = true
    @Published var cpuPlayAs: Player = .o
    
    private let winLines: [[Int]] = [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
    ]
    
    func reset(starting player: Player = .x){
        board = Array(repeating: nil,count: 9)
        current = player
        winner = nil
        isDraw = false
    }
    
    func play(at index:Int) {
        guard winner == nil, !isDraw, index >= 0, index < 9, board[index] == nil else {return}
        board[index] = current
        evaluate()
        if winner == nil, !isDraw {
            current = current.next
            scheduleCPUMoveIfNeeded()
        }
    }
    
    private func evaluate() {
        for line in winLines {
            if let p = board[line[0]],
               board[line[1]] == p,
               board[line[2]] == p {
                winner = p
                return
            }
        }
    }
    
    private func scheduleCPUMoveIfNeeded() {
        guard vsCPU, current == cpuPlayAs, winner == nil, !isDraw else {return}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.cpuMove()
        }
    }
    
    private func cpuMove() {
        guard winner == nil, !isDraw else {return}
        if let move = bestMove(for: cpuPlayAs){
            play(at: move)
        }
    }
    
    private func bestMove(for player: Player) -> Int?{
        let open = availableIndices()
        
        for i in open {
            board[i] = player
            let w = isWinning(player)
            board[i] = nil
            if w {return i}
        }
        
        let opp = player.next
        for i in open {
            board[i] = opp
            let w = isWinning(opp)
            board[i] = nil
            if w { return i }
        }
        
        if open.contains(4) {return 4}
        
        for c in [0, 2, 6, 8] where open.contains(c) { return c}
        
        return open.first
    }
    
    private func isWinning(_ player: Player) -> Bool {
        winLines.contains {
            line in line.allSatisfy { board[$0] == player }
        }
    }
    
    private func availableIndices() -> [Int] {
        (0..<9).filter { board[$0] == nil }
    }
}
