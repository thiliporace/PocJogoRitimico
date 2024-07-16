//
//  NFactory.swift
//  TesteJogoRitimico
//
//  Created by Marina Martin on 16/07/24.
//

import Foundation

protocol NFactory{
    func createNoteObject(position: CGPoint, type: colorType, travelTime: Double) -> NoteObject
}
