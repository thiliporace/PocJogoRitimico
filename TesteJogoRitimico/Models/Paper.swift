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
    var color: PaperColor
    
    init(position: CGPoint, color: PaperColor, node: SKShapeNode) {
        self.position = position
        self.color = color
        
        self.node = node
        node.setScale(0.5)
        node.zPosition = 0
        node.position = position
        let action = SKAction.moveTo(y: 0, duration: 1.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action,remove])
        node.run(sequence)
    }
    
    
    func update() {
        if touched{
            node.fillColor = .gray        }       
    }
    
    
}
