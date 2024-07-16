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
    
    var player: AVAudioPlayer?
    var play: Bool = false
    
    var time: Float = 0
    var isRendering = false
    
    func playSound(_ nome: String, _ ext: String) {
        guard let url = Bundle.main.url(forResource: nome, withExtension: ext) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
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
        
//        
//        if  !player!.isPlaying{
//            gameData?.gameState = .menu
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
//                resetGame()
//                
//            })
//        }
//
    }
    
    // MARK: Touch began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        
        if let objects = gameData?.music2Buttons {
            for object in objects {
                
                if let button = object as SKShapeNode? {
                    if button.contains(touch!) {
                        if button.fillColor == .gamePink {
                            print("toquei")
                            //func pink
                        } else if button.fillColor == .blue {
                            //func blue
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Funcs
    
    func beatNote(){
        if floor((time.truncatingRemainder(dividingBy: 1.5))) == 0 && !isRendering{
                
                isRendering = true
                gameData?.createNFactory(factory: NoteFactory(), type: .pinkType)
                print("mandei renderizar")
                renderNote()
            }
        else if floor(time.truncatingRemainder(dividingBy: 1.5)) != 0 && isRendering{
                print("parei de renderizar")
                isRendering = false
            }
    }
    
    func renderNote(){
        print(gameData?.notes.count)
        if let notes = gameData?.notes {
            print("rederizei")
            addChild(notes.last!.node)
        }
    }
}
