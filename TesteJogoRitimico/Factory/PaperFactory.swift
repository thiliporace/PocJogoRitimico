//
//  PaperFactory.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation
import UIKit

class PaperFactory: GOFactory {
    func createGameObject(position: CGPoint) -> GameObject {
        let paper: Paper = Paper(position: position)
        
        return paper
    }
}
