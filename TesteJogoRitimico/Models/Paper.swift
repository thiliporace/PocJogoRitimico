//
//  Paper.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation
import SpriteKit

class Paper: GameObject{
    var position: CGPoint
    var node: SKShapeNode
    var touched: Bool = false
    var state: Int = 0
    var isOnArea: Bool = false
    var remove: Bool = false
    var color: PaperColor
    
    init(position: CGPoint, color: PaperColor, node: SKShapeNode) {
        self.position = position
        self.color = color
        
        self.node = node
        node.setScale(0.5)
        node.zPosition = 0
        node.position = position
        let action = SKAction.moveTo(y: 0, duration: 1.2)
//        let custom = SKAction.customAction(withDuration: 0.6, actionBlock: { [self] _,_ in
//            self.remove = true
//        })
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action,remove])
        node.run(sequence)
    }
    
    
    func update() {
        
        switch state {
        case 0:
            //ta fora da area
            isOnArea = false
            break
        case 1:
            //ta dentro da area
            isOnArea = true
            
        case 2:
            //saiu da area
            isOnArea = false
            remove = true
            node.removeFromParent()
            
            
        default:
            break
        }
        
        if isOnArea{
            if touched{
                node.fillColor = .gray
                
            }
        }
    }
    
    
}
