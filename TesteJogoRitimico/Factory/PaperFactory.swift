//
//  PaperFactory.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation
import UIKit
import SpriteKit

class PaperFactory: GOFactory {
    func createGameObject(position: CGPoint) -> GameObject {
        let maxValue = PaperColor.allCases.count
        let chosenShapeNumber = arc4random_uniform(UInt32(maxValue))
        let chosenShape = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        switch chosenShapeNumber {
            case 0: chosenShape.fillColor = .red
            case 1: chosenShape.fillColor = .blue
            
            default: chosenShape.fillColor = .blue
        }
        
        print("spawnou: \(PaperColor.allCases[Int(chosenShapeNumber)])")
        
        let paper: Paper = Paper(position: position, color: PaperColor.allCases[Int(chosenShapeNumber)], node: chosenShape)
        
        return paper
    }
}
