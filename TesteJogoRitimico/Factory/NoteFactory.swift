//
//  NoteFactory.swift
//  TesteJogoRitimico
//
//  Created by Marina Martin on 15/07/24.
//

import Foundation
import UIKit

class NoteFactory: NFactory {
    func createNoteObject(position: CGPoint, type: colorType, travelTime: Double) -> NoteObject {
        let note: Note = Note(position: position, type: type, travelTime: travelTime)
        
        return note
    }
}
