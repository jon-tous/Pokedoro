//
//  BackgroundGradient.swift
//  Pokedoro
//
//  Created by Jon Toussaint on 7/21/23.
//

import SwiftUI

struct BackgroundGradient: View, ShapeStyle {
    var body: some View {
        LinearGradient(colors: [.red, .clear, .clear, .clear, .blue], startPoint: .top, endPoint: .bottom)
            .opacity(0.2)
            .ignoresSafeArea()
    }
}

struct BackgroundGradient_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundGradient()
    }
}
