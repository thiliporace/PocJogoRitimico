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
         create(factory: PaperFactory(), seconds: 2)
    }
   
    func create(factory: GOFactory, seconds: Int){
        
        if seconds <= notesStartDelay{
            let object: GameObject = factory.createEmptyGameObject(position: CGPoint(x: 200/*-paper.size.width*/, y: 860) )
            objects.append(object)
        }
        else {
            let object: GameObject = factory.createGameObject(position: CGPoint(x: 200/*-paper.size.width*/, y: 860) )
            objects.append(object)
        }
        
    }
}
