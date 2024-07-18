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
    
    var gameState = GameState.menu
    enum GameState {
        case menu
        case inGame
        case twoLane
    }
    
    var MenuObjects: [SKNode] = []
    
    var music2Buttons: [SKShapeNode] = []
    
    var score: Int = 0
    
    var objects: [GameObject] = []
    func createPaper(){
         create(factory: PaperFactory())
    }
    func create(factory: GOFactory){
        let object: GameObject = factory.createGameObject(position: CGPoint(x: 0/*-paper.size.width*/, y: UIScreen.main.bounds.height/2) )
        objects.append(object)
        
    }
    
    //var notes: [NoteObject] = []
    var pinkNotes: [NoteObject] = []
    var blueNotes: [NoteObject] = []
    func createNote(type: colorType){
        createNFactory(factory: NoteFactory(), type: type)
    }
    func createNFactory(factory: NFactory, type: colorType){
        
        let note: NoteObject = factory.createNoteObject(position: CGPoint(x: type == .pinkType ? 100 : UIScreen.main.bounds.width-100 , y: 50), type: type, travelTime: 1)
        
        type == .blueType ? blueNotes.append(note) : pinkNotes.append(note)
        
        //notes.append(note)
    }
}
