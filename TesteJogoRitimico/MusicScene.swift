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
    
    var redRectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 90))
    var blueRectangle = SKShapeNode(rect: CGRect(x: 200, y: 0, width: 200, height: 90))
//    var yellowRectangle = SKShapeNode(rect: CGRect(x: 0, y: 90, width: 200, height: 90))
//    var greenRectangle = SKShapeNode(rect: CGRect(x: 200, y: 90, width: 200, height: 90))
    
    var ball = SKShapeNode(ellipseIn: CGRect(x: 30, y: 30, width: 50, height: 50))
    
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: ")
    
    var touched:Bool = false
    
    let actionHide: SKAction = SKAction.hide()
    let actionShow: SKAction = SKAction.unhide()
    let actionWait: SKAction = SKAction.wait(forDuration: 0.2)
    let remove: SKAction = SKAction.removeFromParent()
    
    var bpm: Float = 120
    var secondsPerBeat: Float = 0
    var measure: Int = 1
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
    
//    let initialTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
//        let musicTimer = Timer.scheduledTimer(timeInterval: 2.5, repeats: true)/*, target: self, selector: #selector(fazPapel()), userInfo: nil*/
//    }
    
    override func didMove(to view: SKView) {
        secondsPerBeat = 60 / bpm
        startGame()
    }
    
    //MARK: SetGame
    
    func startGame(){
        //removeAllChildren()
        //gameState = .inGame
        
        setBackground()
        setHands()
        setRectangles()
        setBall()
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(musicStartDelay), repeats: false) { timer in
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
    
    func setHands(){
        stampUp.position = CGPoint(x: 400, y: 400)
        stampUp.zPosition = 1
        
        addChild(stampUp)
        
        stampDown.position = stampUp.position
        stampDown.position.y = stampUp.position.y
        stampDown.zPosition = stampUp.zPosition
        stampDown.isHidden = true
        addChild(stampDown)
        
    }
    
    func setRectangles(){
        redRectangle.fillColor = .red
        redRectangle.zPosition = 1
        
        blueRectangle.fillColor = .blue
        blueRectangle.zPosition = 1
        
        addChild(redRectangle)
        addChild(blueRectangle)

    }
    
    func setBall(){
        ball.fillColor = .gray
        ball.zPosition = 2
        ball.name = "ball"
        
        addChild(ball)
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
        objectCount = Int(player!.duration)
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
        self.point1 = touch!
        
        dragStage = .firstDrag
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dragStage == .firstDrag {
            switch presentBallColor {
            case .red:
                checkPaper(color: .red)
            case .blue:
                checkPaper(color: .blue)
            }
        }
        
        dragStage = .inactive
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        
        if dragStage == .firstDrag {
            
            //1 swipe, indo pra direita
            if touch!.x >= point1.x + 20 && (touch!.y >= point1.y - 20 && touch!.y <= point1.y + 20) {
                print("foi pra direita, 1 swipe")
                dragStage = .secondDrag
                if presentBallColor == .red {
                    presentBallColor = .blue
                    checkPaper(color: .blue)
                }
                dragType = .right
            }
            
            //1 swipe, indo pra esquerda
            else if touch!.x <= point1.x - 20 && (touch!.y >= point1.y - 20 && touch!.y <= point1.y + 20) {
                print("foi pra esquerda, 1 swipe")
                dragStage = .secondDrag
                
                if presentBallColor == .blue {
                    presentBallColor = .red
                    checkPaper(color: .red)
                }

                dragType = .left
            }
            
        }
    }
    
    func checkPaper(color: PaperColor){
        
        switch color {
        case .red:
            let action = SKAction.move(to: CGPoint(x: 30, y: 5), duration: 0.05)
            ball.run(action)
        case .blue:
            let action = SKAction.move(to: CGPoint(x: 230, y: 5), duration: 0.05)
            ball.run(action)

        case .empty:
            print("")
        }
        
        let sequenceShow = SKAction.sequence([actionHide, actionWait, actionShow])
        //mostrar depois esconder a mão
        let sequenceHide = SKAction.sequence([actionShow, actionWait, actionHide])
        
        stampUp.run(sequenceShow)
        stampDown.run(sequenceHide)
        
        if let objects = gameData?.objects {
            
            if let paper = objects.last as? Paper{
                if paper.node.position.y <= 600 && paper.node.position.y >= 200 && paper.color == color{
                    
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
                else{
                    if paper.color != .empty{
                        scorePoints -= 20
                        scoreLabel.text = "Score: \(scorePoints)"
                    }
                    
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
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(musicStartDelay) + 0.5, repeats: false) { [self] timer in
                if  !player!.isPlaying{
                    self.gameData?.gameState = .menu
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                        resetGame()
                        
                    })
                }
                setTimer()
            }
            
        }
        
        
        
        
        if let objects = gameData?.objects {
            for (index, object) in objects.enumerated() {
                if let paper = object as? Paper {
                    paper.update()
                }
            }
        }
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
    
    func setTimer(){
        if !renderPaper{
            Timer.scheduledTimer(withTimeInterval: TimeInterval(secondsPerBeat), repeats: true) { [self] timer in
                
                if objectCount >= 0{
                    measure += 1
                    
                    objectCount -= 1
                    gameData?.create(factory: PaperFactory(), delay: self.seconds)
                    self.renderLast()
                    
                    if self.measure >= 4{
                        self.measure = 1
                    }
                }
                
                
            }
            renderPaper = true
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
