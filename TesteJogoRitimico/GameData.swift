//
//  GameData.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation
import SpriteKit
import UIKit

@Observable class GameData{
    let back: SKSpriteNode = SKSpriteNode(imageNamed: "Background")
    let paper: SKSpriteNode = SKSpriteNode(imageNamed: "PaperNormal")
    
    let notesStartDelay: Int = 2
    
    var gameState = GameState.menu
    enum GameState {
        case menu
        case inGame
    }
    
    var objects: [GameObject] = []
    var MenuObjects: [SKNode] = []
    var score: Int = 0
    
    func createPaper(){
         create(factory: PaperFactory(), delay: 2)
    }
   
    func create(factory: GOFactory, delay: Int){
        
        if delay <= notesStartDelay{
            let object: GameObject = factory.createEmptyGameObject(position: CGPoint(x: 200/*-paper.size.width*/, y: 860) )
            objects.append(object)
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(notesStartDelay), repeats: false) { timer in
                self.objects.removeAll()
            }
        }
        else {
            let object: GameObject = factory.createGameObject(position: CGPoint(x: 200/*-paper.size.width*/, y: 860) )
            objects.append(object)
        }
        
    }
}
