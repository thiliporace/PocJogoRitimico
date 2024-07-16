//
//  GOFactory.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 02/07/24.
//

import Foundation

protocol GOFactory{
    func createGameObject(position: CGPoint) -> GameObject
    
    func createEmptyGameObject(position: CGPoint) -> GameObject
}
