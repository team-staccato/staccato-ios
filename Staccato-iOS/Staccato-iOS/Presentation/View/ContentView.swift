//
//  ContentView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Image(systemName: "minus.circle")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .white)
                .background(.black)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
