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

    var gameLogo: SKLabelNode!
    var playButton: SKShapeNode!

    var board: Board!
    var turnLabel: SKLabelNode!
    var playerTurn: String = "Red"
    var gameBG: SKShapeNode!

    override func didMove(to view: SKView) {
        initializaMenu()
        board = Board()



    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for touchedNode in touchedNode {
                if touchedNode.name == "play_button" {
                    startGame()
                }
                for column in self.board.columns {
                    if let dropper = column.dropper, dropper == touchedNode {
                        board.dropChip(in: column)
                        board.updateDisplay()
                        changeTurnLabel()
                    }
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    private func initializaMenu() {
        gameLogo = SKLabelNode(fontNamed: "Futura")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 75
        gameLogo.text = "Connect Four"
        gameLogo.fontColor = SKColor.systemPink
        self.addChild(gameLogo)

        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        playButton.fillColor = SKColor.systemPink
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
    }

    private func startGame() {
        print("start game")

        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
            }

        playButton.run(SKAction.scale(to: 0, duration: 0.3)){
            self.playButton.isHidden = true
        }
        createBoard()
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
        turnLabel = SKLabelNode(fontNamed: "Futura")
        turnLabel.zPosition = 1
        turnLabel.position = CGPoint(x: 0, y: height / 2 - 600)
        turnLabel.text = "Red Player's Turn"
        turnLabel.fontColor = SKColor.red
        addChild(turnLabel)
    }

    private func changeTurnLabel() {
        if playerTurn == "Red" {
            playerTurn = "Black"
            turnLabel.fontColor = SKColor.black
        } else if playerTurn == "Black" {
            playerTurn = "Red"
            turnLabel.fontColor = SKColor.red
        }
        turnLabel.text = "\(playerTurn)'s Turn"
    }



}
