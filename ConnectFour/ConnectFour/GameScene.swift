//
//  GameScene.swift
//  Mastermind
//
//  Created by Riley John Gibbs on 4/23/20.
//  Copyright © 2020 Riley John Gibbs. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var board: Board!
    var turnLabel: SKLabelNode!
    var whosTurn: String = "Red"
    var resetButton: SKShapeNode!
    var resetLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        board = Board()
        createBoard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for touchedNode in touchedNodes {
                for column in self.board.columns {
                    if let dropper = column.dropper, dropper == touchedNode {
                        board.dropChip(in: column)
                        board.updateDisplay()
                        changeTurnLabel()
                    }
                    if let button = self.resetButton, button == touchedNode {
                        board.resetBoard()
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
//    private func creatResetBtn(x: CGFloat, y: CGFloat, cellWidth: CGFloat) {
//
//    }
    
    private func createBoard() {
        let width: CGFloat = frame.size.width * 7 / 9
        let cellWidth: CGFloat = width / CGFloat(board.NUM_COLUMNS)
        let height = cellWidth * CGFloat(board.NUM_ROWS)
        var x = width / -2 + cellWidth / 2
        var y = height / -2 + cellWidth / 2
        for col in board.columns {
            for cell in col.cells {
                let node = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                node.zPosition = 2
                node.position = CGPoint(x: x, y: y)
                node.strokeColor = SKColor.black
                cell.node = node
                cell.fill()
                addChild(node)
                y += cellWidth
            }
            let dropper = SKShapeNode()
            dropper.zPosition = 2
            dropper.position = CGPoint(x: x, y: y + cellWidth)
            dropper.fillColor = SKColor.cyan
            let path = CGMutablePath()
            path.addLines(between: [
                CGPoint(x: -cellWidth / 2 + 10, y: cellWidth / 2 - 10),
                CGPoint(x: cellWidth / 2 - 10, y: cellWidth / 2 - 10),
                CGPoint(x: 0, y: -cellWidth / 2 + 10)
            ])
            dropper.path = path
            addChild(dropper)
            col.dropper = dropper
            x += cellWidth
            y = height / -2 + cellWidth / 2
        }
        let button = SKShapeNode()
       button.zPosition = 1
       button.position = CGPoint(x: x, y: y + cellWidth)
       button.fillColor = SKColor.orange
       let path = CGMutablePath()
       path.addLines(between: [
            CGPoint(x: -cellWidth / 2 - 410, y: cellWidth / 2 - 220),//top left
            CGPoint(x: cellWidth / 2 - 260, y: cellWidth / 2 - 220),//top right
            CGPoint(x: cellWidth / 2 - 260, y: -cellWidth / 2 - 200),//bot right
            CGPoint(x: -cellWidth / 2 - 410, y: -cellWidth / 2 - 200)//bot left
       ])
       button.path = path
        self.resetButton = button
       addChild(button)

        turnLabel = SKLabelNode(fontNamed: "ArialRoundMTBold")
        turnLabel.zPosition = 1
        turnLabel.position = CGPoint(x: 0, y: height / 2 + 170)
        turnLabel.text = "\(whosTurn)'s Turn"
        turnLabel.fontColor = SKColor.red
        self.addChild(turnLabel)
        
        resetLabel = SKLabelNode(fontNamed: "ArialRoundMTBold")
        resetLabel.zPosition = 2
        resetLabel.position = CGPoint(x: 0, y: height / 2 - 592)
        resetLabel.text = "Reset Game"
        resetLabel.fontColor = SKColor.white
        self.addChild(resetLabel)
        
        
    }
    
    func changeTurnLabel() {
        if whosTurn == "Red" {
            whosTurn = "Black"
            turnLabel.fontColor = SKColor.white
        } else if whosTurn == "Black" {
            whosTurn = "Red"
            turnLabel.fontColor = SKColor.red
        }
        turnLabel.text = "\(whosTurn)'s Turn"
    }
}
