//
//  StaccatoCollectionCell.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/14/25.
//

import SwiftUI

import Kingfisher

struct StaccatoCollectionCell: View {

    private let staccato: CategoryDetailModel.StaccatoModel

    private let width: CGFloat

    init(_ staccato: CategoryDetailModel.StaccatoModel, width: CGFloat) {
        self.staccato = staccato
        self.width = width
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(URL(string: staccato.staccatoImageUrl ?? ""))
                .resizable()
                .placeholder {
                    Color.staccatoWhite
                        .frame(width: width, height: width * 1.25)
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width * 1.25)

            linearGradient
                .frame(width: width, height: width * 1.25)

            descriptionStack
        }
        .frame(width: width, height: width * 1.25)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

}


// MARK: - UI Components

private extension StaccatoCollectionCell {

    var descriptionStack: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(staccato.staccatoTitle)
                .typography(.title3)

            HStack(spacing: 4) {
                Image(.calendar)

                let date = Date(fromISOString: staccato.visitedAt)
                let dateStr = date?.formattedAsRequestDate
                Text(dateStr ?? "")
            }
            .typography(.body4)
        }
        .padding(.bottom, 10)
        .padding(.horizontal, 12)
        .foregroundStyle(.staccatoWhite)
    }

    var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.staccatoBlack.opacity(0.1), location: 0.0),
                .init(color: Color.staccatoBlack.opacity(0.5), location: 0.65),
                .init(color: Color.staccatoBlack.opacity(0.7), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

}
