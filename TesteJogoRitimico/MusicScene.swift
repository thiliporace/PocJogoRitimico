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
    
    enum PresentBallColor{
        case red
        case blue
    
    }
    
 

    var gameData: GameData?
    
    let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 20000, height: 10000))
    
    var paperNormal: SKSpriteNode = SKSpriteNode(imageNamed: "PaperNormal")
    var paperSigned: SKSpriteNode = SKSpriteNode(imageNamed: "PaperSigned")
    var stampDown: SKSpriteNode = SKSpriteNode(imageNamed: "StampDown")
    var stampUp: SKSpriteNode = SKSpriteNode(imageNamed: "StampUp")
    
    var redRectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 140))
    var blueRectangle = SKShapeNode(rect: CGRect(x: 200, y: 0, width: 200, height: 140))
    
    
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: ")
    
    var touched:Bool = false
    
    let actionHide: SKAction = SKAction.hide()
    let actionShow: SKAction = SKAction.unhide()
    let actionWait: SKAction = SKAction.wait(forDuration: 0.2)
    
    
    var bpm: Float = 120
    var secondsPerBeat: Float = 0
    var measure: Float = 0.5
  
    var beatCount:Int = 0
    var timerIntervalPerBeat: TimeInterval = 0
    var musicDuration = 0
    
    var startMusic: Bool = false
    var player: AVAudioPlayer?
    var play: Bool = false
    var startConductor = false
    var objectCount = 0
    var scorePoints = 0
    var comboPoints = 0
    
    var time: Float = 0
    
    var presentBallColor: PresentBallColor = .red
    
    var point1: CGPoint = CGPoint(x: 0, y: 0)
    
    var renderTime: TimeInterval = 0
    var changeTime: TimeInterval = 0.25
    var seconds:Double = 0
    var minutes:Int = 0
    
    let musicStartDelay: Double = 1.50
    
    var songBeats: Float = 0.5
    
    var spawnBeat_1: Bool = false
    var spawnBeat_1_5: Bool = false
    var spawnBeat_2: Bool = false
    var spawnBeat_2_5: Bool = false
    var spawnBeat_3: Bool = false
    var spawnBeat_3_5: Bool = false
    var spawnBeat_4: Bool = false
    var spawnBeat_4_5: Bool = false
    
  
    
    var checkArea : SKShapeNode = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: 120))
    
    override func didMove(to view: SKView) {
        gameData?.gameState = .inGame
        removeAllChildren()
        secondsPerBeat = 60 / bpm
        startGame()
    }
    
    //MARK: SetGame
    
    func startGame(){
  
        setCheckArea()
        setBackground()
        
        setRectangles()
        player?.prepareToPlay()
        print("start GAME SCENE")
          
        
        
        //MARK: Musica inicia
        
        player?.pause()
        
        
        setScore()
    }
    func setCheckArea(){
        checkArea.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        checkArea.fillColor = .clear
        checkArea.strokeColor = .black
        checkArea.lineWidth = 4
        checkArea.zPosition = 100
        addChild(checkArea)
    }
    
    func setBackground() {
        
        background.fillColor = .white
        background.zPosition = -99
        addChild(background)
        
    }
    
 
    
    func setRectangles(){
        redRectangle.fillColor = .red
        redRectangle.zPosition = 1
        
        blueRectangle.fillColor = .blue
        blueRectangle.zPosition = 1
        
        addChild(redRectangle)
        addChild(blueRectangle)
        
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
    
    
    
    func setScore(){
        scoreLabel.position = CGPoint(x: 250, y: 700)
        scoreLabel.zPosition = 10
        scoreLabel.isUserInteractionEnabled = false
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 24
        addChild(scoreLabel)
    }
    
    //MARK: Set Gameplay
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        print("toque")
        if blueRectangle.frame.contains(touch!) {
            checkPaper(color: .blue)
        }
        else if redRectangle.frame.contains(touch!) {
            checkPaper(color: .red)
        }
    }
    
    func checkPaper(color: PaperColor){
        
        let sequenceShow = SKAction.sequence([actionHide, actionWait, actionShow])
        //mostrar depois esconder a mão
        let sequenceHide = SKAction.sequence([actionShow, actionWait, actionHide])
        
        stampUp.run(sequenceShow)
        stampDown.run(sequenceHide)
        //        print("clicou: \(color)")
        if let objects = gameData?.objects {
            
            if let paper = objects.first as? Paper {
//                print(paper.state)
//                print(paper.color)
//                print(color)
                if paper.state == 1 && paper.color == color{
                    
                    paper.touched = true
                    print("ACERTOU")
                    let generator = UIImpactFeedbackGenerator(style: .soft)
                    generator.prepare()
                    let animation: SKAction = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
                        if !(gameData?.objects.isEmpty)!{
                            
                            gameData?.objects.removeFirst()
                        }
                    })
                    let sequence = SKAction.sequence([animation])
                    paper.node.run(sequence)
                    generator.impactOccurred()
                    scorePoints += 10
                    scoreLabel.text = "Score: \(scorePoints)"
                }
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        calculateTime(currentTime: currentTime)
        
        if seconds >= musicStartDelay && !startMusic{
            startMusic = true
            print("music start")
            self.playSound("Music1","wav")
            
        }
        
        if !startConductor && seconds >= (musicStartDelay - Double(secondsPerBeat + secondsPerBeat / 2)){
            startConductor = true
            print("notes start")
            conductorNotes()
            
            
        }
        
        if let objects = gameData?.objects {
            if let paper = objects.first as? Paper{
                paper.update()
                
                if checkArea.frame.contains(paper.node.position){
                    paper.state = 1
//                    print("state 1")
                }else{
                    if paper.isOnArea{
                        paper.touched = false
                        paper.state = 2
//                        print("state 2")
                        print(paper.state)
                    }
//                    print("state 0")
//                    print(paper.state)
                }
                if paper.remove && !(gameData?.objects.isEmpty)!{
                    gameData?.objects.removeFirst()
                }
            }
        }
        
        if gameData?.gameState == .menu{
            gameData!.menu.gameData = gameData
            gameData!.menu.scaleMode = .aspectFill
            self.view?.presentScene(gameData!.menu)
        }
        
        
    }
    
    func calculateTime(currentTime: TimeInterval){
        if currentTime > renderTime{
            if renderTime > 0{
                seconds += 0.25
//                print("segundos: \(seconds)")
                
            }
            renderTime = currentTime + changeTime
        }
    }
    
    func conductorNotes(){
        var initialTimer: Timer?
        
        initialTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(secondsPerBeat / 2), repeats: true) { [self] timer in
        
            songBeats += 0.5
            measure += 0.5
            
            
            if self.measure >= 5 {
                self.measure = 1
            }
            
            
            if songBeats > 0{
                spawnBeat_1 = true
                spawnBeat_1_5 = true
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = true
                spawnBeat_3_5 = false
                spawnBeat_4 = true
                spawnBeat_4_5 = true
//                print(spawnBeat_1)
//                print(spawnBeat_1_5)
//                print(spawnBeat_2)
//                print(spawnBeat_2_5)
//                print(spawnBeat_3)
//                print(spawnBeat_3_5)
//                print(spawnBeat_4)
//                print(spawnBeat_4_5)
            }
            if songBeats >= 5  {
                spawnBeat_1 = true
                spawnBeat_1_5 = false
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = false
                spawnBeat_3_5 = false
                spawnBeat_4 = false
                spawnBeat_4_5 = false
          
              
            }
            if songBeats >= 9 {
                spawnBeat_1 = true
                spawnBeat_1_5 = true
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = true
                spawnBeat_3_5 = false
                spawnBeat_4 = true
                spawnBeat_4_5 = true
            }
            if songBeats >= 13 {
                spawnBeat_1 = true
                spawnBeat_1_5 = false
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = false
                spawnBeat_3_5 = false
                spawnBeat_4 = false
                spawnBeat_4_5 = false
            }
            if songBeats >= 17 {
                spawnBeat_1 = true
                spawnBeat_1_5 = true
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = true
                spawnBeat_3_5 = true
                spawnBeat_4 = false
                spawnBeat_4_5 = false
            }
            if songBeats >= 21 {
                spawnBeat_1 = false
                spawnBeat_1_5 = false
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = true
                spawnBeat_3_5 = true
                spawnBeat_4 = false
                spawnBeat_4_5 = false
            }
            if songBeats >= 25 {
                spawnBeat_1 = true
                spawnBeat_1_5 = true
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = false
                spawnBeat_3_5 = false
                spawnBeat_4 = true
                spawnBeat_4_5 = true
            }
            if songBeats >= 29 {
                spawnBeat_1 = true
                spawnBeat_1_5 = true
                spawnBeat_2 = true
                spawnBeat_2_5 = true
                spawnBeat_3 = false
                spawnBeat_3_5 = false
                spawnBeat_4 = true
                spawnBeat_4_5 = true
            }
            //Nao produz nota a partir daqui mesmo com a musica ainda tocando
            if songBeats >= 33 {
                spawnBeat_1 = false
                spawnBeat_1_5 = false
                spawnBeat_2 = false
                spawnBeat_2_5 = false
                spawnBeat_3 = false
                spawnBeat_3_5 = false
                spawnBeat_4 = false
                spawnBeat_4_5 = false
            }
            if songBeats >= 40 {
               //reseta game
                resetGame()
            }
            
            switch measure{
            case 1:
                if spawnBeat_1{
//                    print("songBeats: \(songBeats)")
//                    print("spawn 1")
                    spawnNote()
                }
            case 1.5:
                if spawnBeat_1_5{
//                    print("songBeats: \(songBeats)")
//                    print("spawn 1.5")
                    spawnNote()
                }
            case 2:
                if spawnBeat_2{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 2")
                }
            case 2.5:
                if spawnBeat_2_5{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 2.5")
                }
            case 3:
                if spawnBeat_3{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 3")
                }
            case 3.5:
                if spawnBeat_3_5{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 3.5")
                }
            case 4:
                if spawnBeat_4{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 4")
                }
            case 4.5:
                if spawnBeat_4_5{
                    spawnNote()
//                    print("songBeats: \(songBeats)")
//                    print("spawn 4.5")
                }
            default:
                break
            }
            //                if !player!.isPlaying{
            //                    initialTimer?.invalidate()
            //                    initialTimer = nil
            //                }
        }
    }
    
    func spawnNote(){
        gameData?.create(factory: PaperFactory())
        self.renderLast()
    }
    
    
    func renderLast(){
        if let objects = gameData?.objects {
            addChild(objects.last!.node)
        }
    }
    
    func resetGame(){
        //MARK: Ending
        secondsPerBeat = 0
        songBeats = 0.5
        measure = 0.5
        scoreLabel = SKLabelNode(text: "Score: ")
        beatCount = 0
        timerIntervalPerBeat = 0
        musicDuration = 0
      
        startMusic = false
        startConductor = false
        objectCount = 0
        scorePoints = 0
        comboPoints = 0
        time = 0
        renderTime = 0
        changeTime = 0.25
        seconds = 0
        minutes = 0
        songBeats = 0.5
        spawnBeat_1 = false
        spawnBeat_1_5 = false
        spawnBeat_2 = false
        spawnBeat_2_5 = false
        spawnBeat_3 = false
        spawnBeat_3_5 = false
        spawnBeat_4 = false
        spawnBeat_4_5 = false
        gameData?.objects.removeAll()
        gameData?.gameState = .menu
    }
    
    @objc func papel(){
        startConductor = true
    }
}
