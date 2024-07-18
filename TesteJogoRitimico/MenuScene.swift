//
//  MenuScene.swift
//  TesteJogoRitimico
//
//  Created by Marina Martin on 11/07/24.
//

import Foundation
import SpriteKit

class MenuScene: SKScene{
    let PlayBttn: SKNode = SKNode()
    
    var gameData: GameData?
    
    let game = MusicScene(size: UIScreen.main.bounds.size)
    
    override func didMove(to view: SKView) {
        gameData?.gameState = .menu
        setMenu()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameData?.gameState == .inGame{
            
            //testar se reseta o menu ou não
            //removeAllChildren()
            
            game.gameData = gameData
            game.scaleMode = .aspectFill
            self.view?.presentScene(game)
        }
    }
    
    func setMenu(){
        removeAllChildren()
        let playNode: SKLabelNode = SKLabelNode(text: "Play")
        playNode.fontSize = 40
        playNode.fontColor = .black
        playNode.zPosition = 0
        let backNode: SKShapeNode = SKShapeNode(rect: CGRect(origin: CGPoint(x: (-playNode.frame.width/2 - 10), y: -playNode.frame.height/2), size: CGSize(width: 80, height: 60)))
        backNode.fillColor = .white
        backNode.strokeColor = .black
        backNode.lineWidth = 3
        backNode.zPosition = -1
        
        PlayBttn.addChild(backNode)
        PlayBttn.addChild(playNode)
        PlayBttn.name = "play"
        PlayBttn.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        addChild(PlayBttn)
        
        gameData?.MenuObjects.append(PlayBttn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        
        if let objects = gameData?.MenuObjects {
            for (index, object) in objects.enumerated() {
                
                if let button = object as? SKNode {
                    
                    if button.contains(touch!) {
                        if button.name == "play"{
                            //startGame()
                            gameData?.gameState = .inGame
                        }
                    }
                }
            }
        }
    }
}
