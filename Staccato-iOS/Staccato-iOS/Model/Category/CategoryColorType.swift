//
//  File.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/7/25.
//

import SwiftUI

enum CategoryColorType: CaseIterable {

    case pinkLight, pink
    case RedLight, red
    case orangeLight, orange
    case yellowLight, yellow
    case greenLight, green
    case mintLight, mint
    case blueLight, blue
    case staccatoBlueLight, staccatoBlue
    case purpleLight, purple
    case brownLight, brown
    case grayLight, gray

    static func fromServerKey(_ key: String) -> CategoryColorType? {
        return allCases.first { $0.serverKey == key }
    }

    var color: Color {
        switch self {
        case .pink: return .markerPink
        case .pinkLight: return .markerPinkLight
        case .red: return .markerRed
        case .RedLight: return .markerRedLight
        case .orange: return .markerOrange
        case .orangeLight: return .markerOrangeLight
        case .yellow: return .markerYellow
        case .yellowLight: return .markerYellowLight
        case .green: return .markerGreen
        case .greenLight: return .markerGreenLight
        case .mint: return .markerMint
        case .mintLight: return .markerMintLight
        case .blue: return .markerBlue
        case .blueLight: return .markerBlueLight
        case .staccatoBlue: return .staccatoBlue
        case .staccatoBlueLight: return .markerStaccatoBlueLight
        case .purple: return .markerPurple
        case .purpleLight: return .markerPurpleLight
        case .brown: return .markerBrown
        case .brownLight: return .markerBrownLight
        case .gray: return .gray4
        case .grayLight: return .markerGrayLight
        }
    }

    var textColor: Color {
        switch self {
        case .pinkLight: return .markerTxtPinkLight
        case .RedLight: return .markerTxtRedLight
        case .orangeLight: return .markerTxtOrangeLight
        case .yellowLight: return .markerTxtYellowLight
        case .greenLight: return .markerTxtGreenLight
        case .mintLight: return .markerTxtMintLight
        case .blueLight: return .markerTxtBlueLight
        case .staccatoBlueLight: return .markerTxtStaccatoBlueLight
        case .purpleLight: return .markerTxtPurpleLight
        case .brownLight: return .markerTxtBrownLight
        case .grayLight: return .markerTxtGrayLight
        default: return .staccatoWhite
        }
    }

    // TODO: 명세 나오면 수정하기
    var serverKey: String {
        switch self {
        case .pink: return "PINK"
        case .pinkLight: return "PINK_LIGHT"
        case .red: return "RED"
        case .RedLight: return "RED_LIGHT"
        case .orange: return "ORANGE"
        case .orangeLight: return "ORANGE_LIGHT"
        case .yellow: return "YELLOW"
        case .yellowLight: return "YELLOW_LIGHT"
        case .green: return "GREEN"
        case .greenLight: return "GREEN_LIGHT"
        case .mint: return "MINT"
        case .mintLight: return "MINT_LIGHT"
        case .blue: return "BLUE"
        case .blueLight: return "BLUE_LIGHT"
        case .staccatoBlue: return "STACCATO_BLUE"
        case .staccatoBlueLight: return "STACCATO_BLUE_LIGHT"
        case .purple: return "PURPLE"
        case .purpleLight: return "PURPLE_LIGHT"
        case .brown: return "BROWN"
        case .brownLight: return "BROWN_LIGHT"
        case .gray: return "GRAY"
        case .grayLight: return "GRAY_LIGHT"
        }
    }

    var folderIcon: some View {
        ZStack {
            Circle()
                .foregroundStyle(self.color.opacity(0.15))
                .frame(width: 32, height: 32)
            Image(StaccatoIcon.folderFill)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(self.color)
                .frame(width: 17, height: 17)
        }
    }

    var markerImage: Image {
        switch self {
        case .pink: return Image(.markerPink)
        case .pinkLight: return Image(.markerPinkLight)
        case .red: return Image(.markerRed)
        case .RedLight: return Image(.markerRedLight)
        case .orange: return Image(.markerOrange)
        case .orangeLight: return Image(.markerOrangeLight)
        case .yellow: return Image(.markerYellow)
        case .yellowLight: return Image(.markerYellowLight)
        case .green: return Image(.markerGreen)
        case .greenLight: return Image(.markerGreenLight)
        case .mint: return Image(.markerMint)
        case .mintLight: return Image(.markerMintLight)
        case .blue: return Image(.markerBlue)
        case .blueLight: return Image(.markerBlueLight)
        case .staccatoBlue: return Image(.markerStaccatoBlue)
        case .staccatoBlueLight: return Image(.markerStaccatoBlueLight)
        case .purple: return Image(.markerPurple)
        case .purpleLight: return Image(.markerPurpleLight)
        case .brown: return Image(.markerBrown)
        case .brownLight: return Image(.markerBrownLight)
        case .gray: return Image(.markerGray)
        case .grayLight: return Image(.markerGrayLight)
        }
    }

}
