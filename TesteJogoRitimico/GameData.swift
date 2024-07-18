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
    let menu = MenuScene(size:UIScreen.main.bounds.size)

    let notesStartDelay: Int = 0
    
    var gameState = GameState.menu
    enum GameState {
        case menu
        case inGame
    }
    
    var objects: [GameObject] = []
    var MenuObjects: [SKNode] = []
    var score: Int = 0
    
    func createPaper(){
         create(factory: PaperFactory())
    }
   
    func create(factory: GOFactory){
        
        let object: GameObject = factory.createGameObject(position: CGPoint(x: 200/*-paper.size.width*/, y: 860) )
        objects.append(object)
    }
}
