//
//  Scene.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 26/06/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var background: SKSpriteNode = SKSpriteNode(imageNamed: "Background")
    var paperNormal: SKSpriteNode = SKSpriteNode(imageNamed: "PaperNormal")
    var paperSigned: SKSpriteNode = SKSpriteNode(imageNamed: "PaperSigned")
    var stampDown: SKSpriteNode = SKSpriteNode(imageNamed: "StampDown")
    var stampUp: SKSpriteNode = SKSpriteNode(imageNamed: "StampUp")
    
    var touched: Bool = false
    var paperInScene: Bool = false
    var readyToTouch: Bool = false
    var touchedPaper: Bool = false
    let drums: SKAction = SKAction.playSoundFileNamed("drums", waitForCompletion: true)
    //actions
    let actionHide: SKAction = SKAction.hide()
    let actionShow: SKAction = SKAction.unhide()
    let actionWait: SKAction = SKAction.wait(forDuration: 0.2)
    let remove: SKAction = SKAction.removeFromParent()
    //timer
    var changeTimer: TimeInterval = 0.1
    var renderTimer: TimeInterval = 0.0
    var countTime: SKLabelNode = SKLabelNode()
    var seconds: Double = 0
    var milisSeconds: Double = 0
    
    var bpm = 120
    var bpmCount = 0
    var timerInterval = 0
    
    var readyToUpdate = false
    
    override func didMove(to view: SKView) {
        bpmCount = bpm/60
        timerInterval = 1/bpmCount
        setBackground()
        setDrums()
        
    }
    
    
    func setBackground() {
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.position = CGPoint(x: Int(background.size.width)/2, y: Int(background.size.height)/2)
        addChild(background)
        
        background.zPosition = -999
        
        stampUp.position = CGPoint(x: background.position.x + 200, y: background.position.y)
        stampUp.zPosition = 0
        
        addChild(stampUp)
        
        stampDown.position = stampUp.position
        stampDown.position.y = stampUp.position.y - 100
        stampDown.zPosition = stampUp.zPosition
        stampDown.isHidden = true
        addChild(stampDown)
        
    }
    
    func setDrums(){
        let addDrums = SKShapeNode(rect: CGRect(x: -10000, y: 0, width: 1, height: 1))
        
        addChild(addDrums)
        let repeatSound = SKAction.repeat(drums, count: -1)
        addDrums.run(repeatSound)
        addDrums.isHidden = true
        addDrums.zPosition = -100000
        readyToUpdate = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touched = true
        
        print("touch")
        if seconds == 0 || seconds == 2{
            
            print("segundos 0 ou 2")
            if readyToTouch{
                print("ta pronto pra fazer as animações")
                //esconder depois mostrar
                let sequenceShow = SKAction.sequence([actionHide, actionWait, actionShow])
                //mostrar depois esconder
                let sequenceHide = SKAction.sequence([actionShow, actionWait, actionHide])
                
                stampUp.run(sequenceShow)
                stampDown.run(sequenceHide)
                touchedPaper = true
                touched = false
                
                
            }
            print("Bateu certo")
        }else{
            let damage = SKAction.customAction(withDuration: 0.05, actionBlock: { [self]_,_ in
                stampUp.alpha = 0.5
            })
            let recover = SKAction.customAction(withDuration: 0.05, actionBlock: { [self]_,_ in
                stampUp.alpha = 1
            })
            let sequnceHit = SKAction.sequence([damage, recover,damage,recover])
            stampUp.run(sequnceHit)
            touched = false
            
            print("Bateu errado")
        }
        
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if !readyToUpdate{
            readyToUpdate = true
        }
        if currentTime > renderTimer{
            if renderTimer > 0{
                if milisSeconds >= 1{
                    seconds += 1
                    milisSeconds = 0
                    
                }else{
                    milisSeconds += 0.1
                    
                }
                
                
            }
            renderTimer = currentTime + Double(timerInterval)
            
        }
        if seconds > 3 {
            seconds = 0
        }
        
        if (seconds == 0 && (milisSeconds < 0.2 || milisSeconds > 0.8)) || (seconds == 2 && (milisSeconds < 0.2 || milisSeconds > 0.8)){
            
            
            if touchedPaper {
                //trocar sprite
                let sequence = SKAction.sequence([actionHide, remove])
                let actionSlideOut: SKAction = SKAction.moveTo(x: background.size.width + paperSigned.size.width, duration: 0.2)
                
                let changeBool = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
                    paperInScene = false
                })
                addChild(paperSigned)
                paperSigned.setScale(0.5)
                paperSigned.position = paperNormal.position
                paperSigned.zPosition = -10
                paperNormal.run(sequence)
                
                let sequenceOut = SKAction.sequence([actionShow,actionSlideOut,remove,changeBool])
                paperSigned.run(sequenceOut)
                touchedPaper = false
                
                readyToTouch = false
            }
            
            
        }
        
        if !paperInScene{
            
            paperSliding()
            print("ME MATAR DEPOIS DESSA")
        }
        
        
    }
    
//    func addPaper(){
//        let actionSlideIn: SKAction = SKAction.moveTo(x: background.size.width/2, duration: 0.2)
//        paperNormal.setScale(0.5)
//        paperNormal.position.x = (-background.size.width - paperNormal.size.width)
//        paperNormal.position.y = background.size.height/2
//        
//        paperNormal.zPosition = -10
//        addChild(paperNormal)
//        paperNormal.run(actionSlideIn)
//        paperNormal.run(actionShow)
//        paperInScene = true
//    }
    
    func paperOut(_ normal: SKSpriteNode){
        let paperSignedCopy: SKSpriteNode = paperSigned
        
        let actionSlideOut: SKAction = SKAction.moveTo(x: background.size.width + paperSignedCopy.size.width, duration: 0.5)
        let newPaper = SKAction.customAction(withDuration: 0, actionBlock: { [self]_,_ in
            paperInScene = false
        })
        let sequence = SKAction.sequence([actionSlideOut, remove,newPaper])
        
        paperSignedCopy.setScale(0.5)
        paperSignedCopy.position = normal.position
        paperSignedCopy.zPosition = -10
        addChild(paperSignedCopy)
        
        
        paperSignedCopy.run(sequence)
        
    }
    
    func paperSliding(){
        let paperNomarCopy: SKSpriteNode = paperNormal
        
        let actionSlideIn: SKAction = SKAction.moveTo(x: background.size.width/2, duration: 0.2)
        
        //wait
        //habilita toque
        let setTouchReady = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
            readyToTouch = true
            print("readytobetouch")
        })
        
        let veryTouch = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
            if touchedPaper {
                //trocar sprite
                let sequence = SKAction.sequence([actionHide, remove])
                
                paperOut(paperNomarCopy)
                paperNomarCopy.run(sequence)
                
            }
        })
        let actioWaitAgain = SKAction.wait(forDuration: 0.3)
        //troca
        let failedTouch = SKAction.customAction(withDuration: 0, actionBlock: { [self] _,_ in
            //sair da tela com o papel normal
            if !touchedPaper{
                let actionSlideOut: SKAction = SKAction.moveTo(x: background.size.width + paperSigned.size.width, duration: 0.5)
                let newPaper = SKAction.customAction(withDuration: 0, actionBlock: { [self]_,_ in
                    paperInScene = false
                    readyToTouch = false
                   
                })
                let sequence = SKAction.sequence([actionSlideOut,remove,newPaper])
                paperNomarCopy.run(sequence)
                print("nao foi tocado e precisa sair")
            }
        })
        
        let sequenceIn = SKAction.sequence([actionSlideIn,setTouchReady, actionWait, actioWaitAgain, veryTouch, failedTouch])
        
        paperInScene = true
        paperNomarCopy.setScale(0.5)
        paperNomarCopy.position.x = (-background.size.width - paperNomarCopy.size.width)
        paperNomarCopy.position.y = background.size.height/2
        paperNomarCopy.zPosition = -10
        addChild(paperNomarCopy)
        paperNomarCopy.run(sequenceIn)
    }
    
    
}
