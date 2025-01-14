//
//  StaccatoCollectionCell.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

struct StaccatoCollectionCell: View {
    let title: String
    let date: Date

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // TODO: 이미지로 변경
            Rectangle()
                .foregroundStyle(.red)

            linearGradient

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .typography(.title3)

                HStack(spacing: 4) {
                    Image(.calendar)

                    Text(date.formattedAsFullDate)
                }
                .typography(.body4)
            }
            .padding(.bottom, 10)
            .padding(.leading, 12)
            .foregroundStyle(.white)
        }
        .frame(width: 160, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    StaccatoCollectionCell(title: "광안리", date: .now)
}

extension StaccatoCollectionCell {
    private var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.black.opacity(0), location: 0.0),
                .init(color: Color.black.opacity(0.5), location: 0.65),
                .init(color: Color.black.opacity(0.7), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
