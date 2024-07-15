//
//  ContentView.swift
//  TesteJogoRitimico
//
//  Created by Rafael Carreira on 26/06/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: MenuScene{
        let scene = MenuScene()
        scene.gameData = GameData()
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        VStack {
            SpriteView(scene: scene, debugOptions: [.showsNodeCount,.showsFPS])
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
