//
//  main.swift
//  tictactoe
//
//  Created by Kanisk Chakraborty on 2020-06-07.
//  Copyright © 2020 Kanisk Chakraborty. All rights reserved.
//

import Foundation

struct TicTacToe {
    var board: [[Int]] // Tic Tac Toe board (row-major format, 3x3 array of integers
}

extension TicTacToe {
    init() {
        self.init(board: [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)) // 3x3 array of zeroes
    }
}

extension TicTacToe {
    func isWin(for player: Int) -> Bool {
        let wanting = [player, player, player] // Expecting 3 in a row
        for i in board {
            if i == wanting {
                return true // Row is equal to what was expected
            }
        }
        for col in 0..<3 {
            let row = [board[0][col], board[1][col], board[2][col]]
            if row == wanting {
                return true // if column is equal to what was expected
            }
        }
        let diag1 = [board[0][0], board[1][1], board[2][2]]
        if diag1 == wanting {
            return true // Right to left diagonal is equal to what was expected
        }
        return false // No win yet for this player
    }
    
    var legalMoves: [(Int, Int)] {
        var legals: [(Int, Int)] = []
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == 0 {
                    legals.append((row, col))
                }
            }
        }
        return legals
    }
    
    var hasWinner: Bool {
        return isWin(for: 1) || isWin(for: -1)
    }
    
    var isOver: Bool {
        return hasWinner || legalMoves.isEmpty
    }
    
    mutating func play(at location: (Int, Int), player: Int) {
        guard board[location.0][location.1] == 0 else {
            fatalError()
        }
        board[location.0][location.1] = player
    }
    
    func children(player: Int) -> [TicTacToe] {
        var nextMoves: [TicTacToe] = []
        for i in legalMoves {
            var copy = TicTacToe(board: board)
            copy.play(at: i, player: player)
            nextMoves.append(copy)
        }
        return nextMoves
    }
    
    func winner(depth: Int) -> Int {
        if isWin(for: 1) {
            return 10 - depth
        }
        if isWin(for: -1) {
            return depth - 10
        }
        return 0
    }
}

extension TicTacToe {
    // Turn a number into a character
    //  0 = " "
    // +1 = "x"
    // -1 = "o"
    static func character(_ x: Int) -> String {
        x == 0 ? " " : (x == 1 ? "x" : "o")
    }
    
    // Print the board
    func display() {
        var boardTemplate: String = """
                               +-+-+-+
                               |1|2|3|
                               +-+-+-+
                               |4|5|6|
                               +-+-+-+
                               |7|8|9|
                               +-+-+-+
                            """
        boardTemplate = boardTemplate.replacingOccurrences(of: "1", with: "\(TicTacToe.character(board[0][0]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "2", with: "\(TicTacToe.character(board[0][1]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "3", with: "\(TicTacToe.character(board[0][2]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "4", with: "\(TicTacToe.character(board[1][0]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "5", with: "\(TicTacToe.character(board[1][1]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "6", with: "\(TicTacToe.character(board[1][2]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "7", with: "\(TicTacToe.character(board[2][0]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "8", with: "\(TicTacToe.character(board[2][2]))")
        boardTemplate = boardTemplate.replacingOccurrences(of: "9", with: "\(TicTacToe.character(board[2][1]))")
        print(boardTemplate, terminator: "\n\n")
    }
}

func minimax(state: TicTacToe, player: Int, depth: Int = 0) -> Double {
    if state.isOver {
        return Double(state.winner(depth: depth)) // return score
    }
    let children = state.children(player: player).map({minimax(state: $0, player: -player, depth: depth + 1)}) // determine children of currenet game state and find minimax scores
    if player == 1 { // if player is maximizing player, then return child with highest score
        return children.max()!
    } else {
        return children.min()! // return child with lowest score for minimizing player
    }
}

func decision(for state: TicTacToe, player: Int) -> (Int, Int) {
    let children = state.children(player: player)
    let scores = children.map({ Double(player) * minimax(state: $0, player: -player) })
    return state.legalMoves[scores.firstIndex(where: { $0 == scores.max()! })!]
}

var state = TicTacToe()
var player = 1
state.display()
while !state.isOver {
    state.play(at: decision(for: state, player: player), player: player)
    player = -player
    state.display()
}




