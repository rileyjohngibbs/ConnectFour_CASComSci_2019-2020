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
    var gameLogo: SKLabelNode!
    var playButton: SKShapeNode!

    override func didMove(to view: SKView) {
        board = Board()
        initializeMenu()
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
        
                    }
                }
            }
            for node in touchedNodes {
                 if node.name == "play_button" {
                     board = Board()
                    menuAnimation()
                     createBoard()
                     playButton.position = CGPoint(x: 0, y: (frame.size.height * 40) + 200)
                         createBoard()
                 }
             }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    private func menuAnimation() {
        print("start game")
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
        }
        
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        
    }

    
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
    }
    private func initializeMenu() {
           gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
           gameLogo.zPosition = 1
           gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
           gameLogo.fontSize = 60
           gameLogo.text = "CONNECT FOUR"
           gameLogo.fontColor = SKColor.yellow
           self.addChild(gameLogo)


           playButton = SKShapeNode()
           playButton.name = "play_button"
           playButton.zPosition = 1
           playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
           playButton.fillColor = SKColor.blue
        
           let topCorner = CGPoint(x: -50, y: 50)
           let bottomCorner = CGPoint(x: -50, y: -50)
           let middle = CGPoint(x: 50, y: 0)
           let path = CGMutablePath()
           path.addLine(to: topCorner)
           path.addLines(between: [topCorner, bottomCorner, middle])
           playButton.path = path
           self.addChild(playButton)
       }
}
