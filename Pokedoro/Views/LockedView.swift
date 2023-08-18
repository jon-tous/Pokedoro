//
//  LockedView.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 8/18/23.
//

import SwiftUI

struct LockedView: View {
    let unlockLevel: Int
    let currentLevel: Int
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            Text("Catch \(unlockLevel - currentLevel) more Pokémon \nand check back!")
                .font(.title).fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct LockedView_Previews: PreviewProvider {
    static var previews: some View {
        LockedView(unlockLevel: 10, currentLevel: 3)
    }
}
