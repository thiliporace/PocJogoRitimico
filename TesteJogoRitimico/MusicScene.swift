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
//        case yellow
//        case green
    }
    
    enum DragStages{
        case inactive
        case firstDrag
        case secondDrag
    }

    enum FirstDragType{
        case inactive
        case up
        case down
        case right
        case left
//        case diagonalUpRight
//        case diagonalUpLeft
//        case diagonalDownLeft
//        case diagonalDownRight
    }
    
    var gameData: GameData?
    
    let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 20000, height: 10000))
//    var background: SKSpriteNode = SKSpriteNode(imageNamed: "Background")
    var paperNormal: SKSpriteNode = SKSpriteNode(imageNamed: "PaperNormal")
    var paperSigned: SKSpriteNode = SKSpriteNode(imageNamed: "PaperSigned")
    var stampDown: SKSpriteNode = SKSpriteNode(imageNamed: "StampDown")
    var stampUp: SKSpriteNode = SKSpriteNode(imageNamed: "StampUp")
    
    var redRectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 140))
    var blueRectangle = SKShapeNode(rect: CGRect(x: 200, y: 0, width: 200, height: 140))
//    var yellowRectangle = SKShapeNode(rect: CGRect(x: 0, y: 90, width: 200, height: 90))
//    var greenRectangle = SKShapeNode(rect: CGRect(x: 200, y: 90, width: 200, height: 90))
        
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: ")
    
    var touched:Bool = false
    
    let actionHide: SKAction = SKAction.hide()
    let actionShow: SKAction = SKAction.unhide()
    let actionWait: SKAction = SKAction.wait(forDuration: 0.2)

    
    var bpm: Float = 120
    var secondsPerBeat: Float = 0
    var measure: Float = 1
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
    var renderPaper = false
    var objectCount = 0
    var scorePoints = 0
    var comboPoints = 0
    
    var time: Float = 0
    
    var dragStage: DragStages = .inactive
    var dragType: FirstDragType = .inactive
    var presentBallColor: PresentBallColor = .red
    
    var point1: CGPoint = CGPoint(x: 0, y: 0)
    
    var renderTime: TimeInterval = 0
    var changeTime: TimeInterval = 1
    var seconds:Int = 0
    var minutes:Int = 0
    
    let musicStartDelay: Int = 1
    
    var songBeats: Float = 1
//    let initialTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
//        let musicTimer = Timer.scheduledTimer(timeInterval: 2.5, repeats: true)/*, target: self, selector: #selector(fazPapel()), userInfo: nil*/
//    }
    
    var checkArea : SKShapeNode = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width, height: 120))
    
    override func didMove(to view: SKView) {
        secondsPerBeat = 60 / bpm
        startGame()
    }
    
    //MARK: SetGame
    
    func startGame(){
        //removeAllChildren()
        //gameState = .inGame
        checkArea.position = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        checkArea.fillColor = .clear
        checkArea.strokeColor = .black
        checkArea.lineWidth = 4
        checkArea.zPosition = 100
        addChild(checkArea)
        setBackground()
//        setHands()
        setRectangles()
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(musicStartDelay) + Double(secondsPerBeat), repeats: false) { timer in
            self.playSound("Music1","wav")
            self.createPaper()
        }
        
        //MARK: Musica inicia
        
        player?.pause()
        player?.prepareToPlay()
        
        setScore()
    }
    
    func setBackground() {
        
        background.fillColor = .white
        background.zPosition = -99
        addChild(background)
        
    }
    
//    func setHands(){
//        stampUp.position = CGPoint(x: 360, y: 480)
//        stampUp.zPosition = 1
//        
//        addChild(stampUp)
//        
//        stampDown.position = stampUp.position
//        stampDown.position.y = stampUp.position.y
//        stampDown.zPosition = stampUp.zPosition
//        stampDown.isHidden = true
//        addChild(stampDown)
//        
//    }
    
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
    
    func createPaper(){
        objectCount = Int(player!.duration) * 2
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
        
        if !play{
            play = true
            player?.play()
            //MARK: Inicia player
        }
        
        if seconds > musicStartDelay {
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(musicStartDelay) + Double(secondsPerBeat), repeats: false) { [self] timer in
                
                
                setInitialTimer()
                
                
                if  !player!.isPlaying{
                    self.gameData?.gameState = .menu
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                        resetGame()
                    })
                }
                
            }
            
        }
        
        if let objects = gameData?.objects {
            if let paper = objects.first as? Paper{
                paper.update()
                if checkArea.frame.contains(paper.node.position){
                    paper.state = 1
                }else{
                    if paper.isOnArea{
                        paper.touched = false
                        paper.state = 2
                    }
                }
                if paper.remove && !(gameData?.objects.isEmpty)!{
                    gameData?.objects.removeFirst()
                }
            }
        }
        
//        if let objects = gameData?.objects {
//            for object in objects {
//                if let paper = object as? Paper {
//                    paper.update()
//                    if paper.remove{
//                        gameData?.objects.removeFirst()
//                    }
//                    if checkArea.frame.contains(paper.node.position){
//                        paper.state = 1
//                    }else{
//                        if paper.isOnArea{
//                            paper.state = 2
//                        }
//                    }
//                }
//            }
//        }
        
//        if let objects = gameData?.objects.first {
//            print(objects.node.position.y)
//        }
        
    }
    
    func calculateTime(currentTime: TimeInterval){
        if currentTime > renderTime{
            if renderTime > 0{
                seconds += 1
                if seconds == 60{
                    seconds = 0
                    minutes += 1
                }
                
            }
            renderTime = currentTime + changeTime
        }
    }
    
    func setInitialTimer(){
        var initialTimer: Timer?
        
        if !renderPaper {
            initialTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(secondsPerBeat / 2), repeats: true) { [self] timer in
                songBeats += 0.5
                measure += 0.5
                
                if self.measure >= 5 {
                    self.measure = 1
                }
                
                switch measure{
                case 1:
                    spawnNote()
                case 2:
                    spawnNote()
                case 3:
                    spawnNote()
                case 4:
                    spawnNote()
                default:
                    break
                }
                
                if songBeats >= 0 && songBeats <= 9 {
                    switch measure{
                    case 3.5:
                        spawnNote()
                    default:
                        break
                    }
                }
                else if songBeats >= 10 && songBeats <= 15 {
                    switch measure{
                    case 0.5:
                        spawnNote()
                    case 1.5:
                        spawnNote()
                    default:
                        break
                    }
                }
                else if songBeats >= 16 && songBeats <= 25 {
                    switch measure{
                    case 2.5:
                        spawnNote()
                    case 3.5:
                        spawnNote()
                    default:
                        break
                    }
                }
                else if songBeats >= 26 && songBeats <= 32 {
                    switch measure{
                    case 1.5:
                        spawnNote()
                    default:
                        break
                    }
                }
                
                
                
                
                
            }
        }
        renderPaper = true
    }
    
    func spawnNote(){
        if objectCount >= 0{
            objectCount -= 1
            gameData?.create(factory: PaperFactory(), delay: self.seconds)
            self.renderLast()
            
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
