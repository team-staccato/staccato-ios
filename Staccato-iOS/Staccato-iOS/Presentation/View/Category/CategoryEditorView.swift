//
//  CategoryEditorView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/7/25.
//

import SwiftUI

struct CategoryEditorView: View {
    @State var isOn = false

    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(StaccatoToggleStyle())

        Toggle("", isOn: $isOn)

    }
}

#Preview {
    CategoryEditorView()
}
