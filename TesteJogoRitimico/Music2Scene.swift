//
//  Music2Scene.swift
//  TesteJogoRitimico
//
//  Created by Marina Martin on 15/07/24.
//

import Foundation
import SpriteKit
import AVFoundation
import UIKit

class Music2Scene: SKScene{
    var gameData: GameData?
    
    var backgroundNotes: SKSpriteNode = SKSpriteNode(imageNamed: "rectangleBackground")
    var pinkButton: SKSpriteNode = SKSpriteNode(imageNamed: "pinkButton")
    var blueButton: SKSpriteNode = SKSpriteNode(imageNamed: "blueButton")
    var goodArea: SKShapeNode = SKShapeNode()
    var finalArea: SKShapeNode = SKShapeNode()
    var feedbackLabel: SKLabelNode = SKLabelNode(text: "")
    
    var player: AVAudioPlayer?
    var play: Bool = false
    
    var time: Float = 0
    var isRendering = false
    
    func playSound(_ nome: String, _ ext: String) {
        guard let url = Bundle.main.url(forResource: nome, withExtension: ext) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Start
    
    override func didMove(to view: SKView) {
        startGame()
    }
    
    func startGame(){
        setBackground()
        setButtons()
        setGoodArea()
        setFinalArea()
        setLabel()
        
        playSound("twoLane","wav")
        player?.pause()
        player?.prepareToPlay()
    }
    
    // MARK: Set Elements
    
    func setBackground() {
        backgroundColor = .white
        
        backgroundNotes.size = CGSize(width: UIScreen.main.bounds.width, height: 90)
        backgroundNotes.position = CGPoint(x: Int(backgroundNotes.size.width)/2, y: Int(backgroundNotes.size.height)/2)
        addChild(backgroundNotes)
        
        backgroundNotes.zPosition = -10
    }
    
    func setButtons(){
        pinkButton.position = CGPoint(x: 50, y: 50)
        addChild(pinkButton)
        pinkButton.zPosition = 1
        
        blueButton.position = CGPoint(x: UIScreen.main.bounds.width - 50, y: 50)
        addChild(blueButton)
        blueButton.zPosition = 1
    }
    
    func setGoodArea(){
        let rectangle = SKShapeNode(rectOf: CGSize(width: 90, height: 90))
        rectangle.fillColor = .gray
        rectangle.position = CGPoint(x: UIScreen.main.bounds.width/2, y: 45)
        goodArea = rectangle
        addChild(goodArea)
        goodArea.zPosition = 1
    }
    
    func setFinalArea(){
        let rectangle = SKShapeNode(rectOf: CGSize(width: 1, height: 90))
        rectangle.fillColor = .clear
        rectangle.strokeColor = .clear
        rectangle.position = CGPoint(x: UIScreen.main.bounds.width/2, y: 45)
        finalArea = rectangle
        addChild(finalArea)
        finalArea.zPosition = 1
    }
    
    func setLabel(){
        feedbackLabel.position = CGPoint(x: 350, y: 100)
        feedbackLabel.zPosition = 10
        feedbackLabel.isUserInteractionEnabled = false
        feedbackLabel.fontColor = .black
        feedbackLabel.fontSize = 30
        addChild(feedbackLabel)
    }
    
    // MARK: Update
    
    override func update(_ currentTime: TimeInterval) {
        if !play{
            play = true
            player?.play()
                        
        }
        
        time = Float(player!.currentTime + 1.0)
        
        if(player!.currentTime > 0.5){
            beatNote()
        }
        
        checkFinalAreaCollision()
    }
    
    // MARK: Touch began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        
        if pinkButton.frame.contains(touch!) {
            locationNote()
        }
    }
    
    // MARK: Funcs
    
    func beatNote(){
        if floor((time.truncatingRemainder(dividingBy: 1.5))) == 0 && !isRendering{
                
                isRendering = true
                gameData?.createNFactory(factory: NoteFactory(), type: .pinkType)
                renderNote()
            }
        else if floor(time.truncatingRemainder(dividingBy: 1.5)) != 0 && isRendering{
                isRendering = false
            }
    }
    
    func renderNote(){
        if let notes = gameData?.notes {
            addChild(notes.last!.node)
        }
    }
    
    func destroyNote(){
        if (gameData?.notes) != nil {
            gameData?.notes.first?.node.removeFromParent()
            gameData?.notes.removeFirst()
        }
    }
    
    func labelAnimation(){
        let action0 = SKAction.fadeIn(withDuration: 0)
        let action = SKAction.moveTo(y: 120, duration: 0.5)
        let action2 = SKAction.fadeOut(withDuration: 0.1)
        let action3 = SKAction.moveTo(y: 100, duration: 0)
        let sequence = SKAction.sequence([action0,action, action2, action3])
        feedbackLabel.run(sequence)
    }
    
    func locationNote(){
        if let notes = gameData?.notes{
            if let note = notes.first as? Note{
                if goodArea.frame.contains(note.node.position){
                    destroyNote()
                    feedbackLabel.text = "Good!"
                   
                }
                else{
                    destroyNote()
                    feedbackLabel.text = "missed..."
                }
                labelAnimation()
            }
        }
    }
    
    func checkFinalAreaCollision(){
        if let notes = gameData?.notes{
            if let note = notes.first as? Note{
                if finalArea.frame.contains(note.node.position){
                    destroyNote()
                    feedbackLabel.text = "missed..."
                    labelAnimation()
                }
            }
        }
    }
}
