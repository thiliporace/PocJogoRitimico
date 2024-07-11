//
//  GameObject.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation
import SpriteKit

protocol GameObject{
    var position: CGPoint { get set }
    var node: SKSpriteNode { get set }

    func update()
    
}
