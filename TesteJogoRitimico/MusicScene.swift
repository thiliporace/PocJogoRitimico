//
//  MusicScene.swift
//  TesteJogoRitimico
//
//  Created by Marina Martin on 11/07/24.
//

import Foundation
import SpriteKit
import AVFoundation
import UIKit

class MusicScene: SKScene{
    var gameData: GameData?
    
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "Background")
    var paperNormal: SKSpriteNode = SKSpriteNode(imageNamed: "PaperNormal")
    var paperSigned: SKSpriteNode = SKSpriteNode(imageNamed: "PaperSigned")
    var stampDown: SKSpriteNode = SKSpriteNode(imageNamed: "StampDown")
    var stampUp: SKSpriteNode = SKSpriteNode(imageNamed: "StampUp")
    
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: ")
    
    var touched:Bool = false
    
    let actionHide: SKAction = SKAction.hide()
    let actionShow: SKAction = SKAction.unhide()
    let actionWait: SKAction = SKAction.wait(forDuration: 0.2)
    let remove: SKAction = SKAction.removeFromParent()
    
    var bpm: Int = 120
    //0,5 player clock vem papel
    //0,5 pra ele chegar
    //primeiro 1,5   - 2
    //segundo 3,5    - 4
    //(tempo do player - 1,5) % 2,5 == 0 -> vem papel
    var beatCount:Int = 0
    var timerIntervalPerBeat: TimeInterval = 0
    var musicDuration = 0
    
    var player: AVAudioPlayer?
    var play: Bool = false
    var renderPaper = true
    var objectCount = 0
    var scorePoints = 0
    
    var time: Float = 0
    
//    let initialTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
//        let musicTimer = Timer.scheduledTimer(timeInterval: 2.5, repeats: true)/*, target: self, selector: #selector(fazPapel()), userInfo: nil*/
//    }
    
    override func didMove(to view: SKView) {
        startGame()
    }
    
    //MARK: SetGame
    
    func startGame(){
        //removeAllChildren()
        //gameState = .inGame
        
        setBackground()
        setHands()
        
        playSound("Metronomo","wav")
        //MARK: Musica inicia
        
        player?.pause()
        player?.prepareToPlay()
        
        createPaper()
        
        setScore()
    }
    
    func setBackground() {
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.position = CGPoint(x: Int(background.size.width)/2, y: Int(background.size.height)/2)
        addChild(background)
        
        background.zPosition = -999
        
    }
    
    func setHands(){
        stampUp.position = CGPoint(x: background.position.x + 200, y: background.position.y)
        stampUp.zPosition = 1
        
        addChild(stampUp)
        
        stampDown.position = stampUp.position
        stampDown.position.y = stampUp.position.y - 100
        stampDown.zPosition = stampUp.zPosition
        stampDown.isHidden = true
        addChild(stampDown)
        
    }
    
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
    
    func createPaper(){
        objectCount = Int(player!.duration)/2
    }
    
    func setScore(){
        scoreLabel.position = CGPoint(x: 730, y: 25)
        scoreLabel.zPosition = 10
        scoreLabel.isUserInteractionEnabled = false
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 24
        addChild(scoreLabel)
    }
    
    //MARK: Set Gameplay
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sequenceShow = SKAction.sequence([actionHide, actionWait, actionShow])
        //mostrar depois esconder a mão
        let sequenceHide = SKAction.sequence([actionShow, actionWait, actionHide])
        
        stampUp.run(sequenceShow)
        stampDown.run(sequenceHide)
        
        if let objects = gameData?.objects {
            
            if let paper = objects.last as? Paper{
                if paper.node.position.x >= 400 && paper.node.position.x <= 500{
                    
                    paper.touched = true
                    
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.prepare()
                    let animation: SKAction = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
                        gameData?.objects.removeFirst()
                    })
                    let sequence = SKAction.sequence([actionWait, animation])
                    paper.node.run(sequence)
                    generator.impactOccurred()
                    scorePoints += 10
                    scoreLabel.text = "Score: \(scorePoints)"
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !play{
            play = true
            player?.play()
                        
            //MARK: Inicia player
        }
        
        time = Float(player!.currentTime + 0.5)
        
        // MARK: falta math
        if floor((time.truncatingRemainder(dividingBy: 2))) == 0 && renderPaper && objectCount != 0 {
            
            objectCount -= 1
            gameData?.create(factory: PaperFactory())
            renderLast()
            renderPaper = false
            
        }
        else if floor(time.truncatingRemainder(dividingBy: 2)) == 1{
            renderPaper = true
        }
        
        if  !player!.isPlaying{
            gameData?.gameState = .menu
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                resetGame()
                
            })
        }
        
        if let objects = gameData?.objects {
            for (index, object) in objects.enumerated() {
                if let paper = object as? Paper {
                    paper.update()
                }
            }
        }
    }
    
    func renderLast(){
        if let objects = gameData?.objects {
            addChild(objects.last!.node)
        }
    }
    
    func resetGame(){
        //MARK: Ending
        
//        gameState = GameState.menu
//        removeAllChildren()
//        setMenu()
//        play = false
//        renderPaper = true
//        objectCount = 0
//        scorePoints = 0
//        scoreLabel = SKLabelNode(text: "Score: 0")
//        gameData?.objects.removeAll()
    }
    
    @objc func papel(){
        renderPaper = true
    }
}
