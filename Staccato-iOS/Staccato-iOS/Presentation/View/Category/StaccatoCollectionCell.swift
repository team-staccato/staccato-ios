//
//  StaccatoCollectionCell.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

import Kingfisher

struct StaccatoCollectionCell: View {

    private let staccato: StaccatoModel

    let width: CGFloat = (ScreenUtils.width - 16 - 8) / 2

    init(_ staccato: StaccatoModel, width: CGFloat) {
        self.staccato = staccato
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: staccato.staccatoImageUrl ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width * 1.25, alignment: .center)
                .clipped()

            linearGradient

            VStack(alignment: .leading, spacing: 7) {
                Text(staccato.staccatoTitle)
                    .typography(.title3)

                HStack(spacing: 4) {
                    Image(.calendar)

                    Text(staccato.visitedAt)
                }
                .typography(.body4)
            }
            .padding(.bottom, 10)
            .padding(.leading, 12)
            .foregroundStyle(.staccatoWhite)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension StaccatoCollectionCell {
    private var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.staccatoBlack.opacity(0), location: 0.0),
                .init(color: Color.staccatoBlack.opacity(0.5), location: 0.65),
                .init(color: Color.staccatoBlack.opacity(0.7), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
