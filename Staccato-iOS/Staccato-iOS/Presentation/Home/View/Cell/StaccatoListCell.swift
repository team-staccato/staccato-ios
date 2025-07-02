//
//  StaccatoListCell.swift
//  Staccato-iOS
//
//  Created by 김유림 on 6/29/25.
//

import SwiftUI

struct StaccatoListCell: View {

    var staccatoInfo: StaccatoCoordinateModel

    init(_ staccatoInfo: StaccatoCoordinateModel) {
        self.staccatoInfo = staccatoInfo
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                titleLabel
                dateLabel
            }

            Spacer()

            markerImage
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
    }

}


// MARK: - UI Components

private extension StaccatoListCell {

    var titleLabel: some View {
        Text(staccatoInfo.title)
            .typography(.title2)
            .foregroundColor(.staccatoBlack)
    }

    @ViewBuilder
    var dateLabel: some View {
        if let date = Date(fromISOString: staccatoInfo.visitedAt) {
            let dateString = date.formattedAsRequestDate
            Text(dateString)
                .typography(.body4)
                .foregroundStyle(.staccatoBlack)
                .padding(.vertical, 2)
                .padding(.horizontal, 7)
                .background(RoundedRectangle(cornerRadius: 7).fill(.gray1))
        }
    }

    var markerImage: some View {
        Image(.icMarker)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 23, height: 26)
            .foregroundStyle(staccatoInfo.staccatoColor.color)
    }

}


// MARK: - Preview

#Preview {
    StaccatoListCell(StaccatoCoordinateModel(id: 1, staccatoId: 1, staccatoColor: .RedLight, latitude: 32.2, longitude: 137.5, title: "hello", visitedAt: "2025-06-10T17:30:04"))
}
