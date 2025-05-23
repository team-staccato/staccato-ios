//
//  File.swift
//  Staccato-iOS
//
//  Created by 김유림 on 5/7/25.
//

import SwiftUI

enum CategoryColorType: CaseIterable {

    case RedLight, red
    case orangeLight, orange
    case yellowLight, yellow
    case greenLight, green
    case mintLight, mint
    case blueLight, blue
    case indigoLight, indigo
    case purpleLight, purple
    case pinkLight, pink
    case brownLight, brown
    case grayLight, gray

    static func fromServerKey(_ key: String) -> CategoryColorType {
        return allCases.first { $0.serverKey == key } ?? .gray
    }

    var color: Color {
        switch self {
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
        case .indigo: return .markerIndigo
        case .indigoLight: return .markerIndigoLight
        case .purple: return .markerPurple
        case .purpleLight: return .markerPurpleLight
        case .pink: return .markerPink
        case .pinkLight: return .markerPinkLight
        case .brown: return .markerBrown
        case .brownLight: return .markerBrownLight
        case .gray: return .gray4
        case .grayLight: return .markerGrayLight
        }
    }

    var textColor: Color {
        switch self {
        case .RedLight: return .markerTxtRedLight
        case .orangeLight: return .markerTxtOrangeLight
        case .yellowLight: return .markerTxtYellowLight
        case .greenLight: return .markerTxtGreenLight
        case .mintLight: return .markerTxtMintLight
        case .blueLight: return .markerTxtBlueLight
        case .indigoLight: return .markerTxtIndigoLight
        case .purpleLight: return .markerTxtPurpleLight
        case .pinkLight: return .markerTxtPinkLight
        case .brownLight: return .markerTxtBrownLight
        case .grayLight: return .markerTxtGrayLight
        default: return .staccatoWhite
        }
    }

    var serverKey: String {
        switch self {
        case .red: return "red"
        case .RedLight: return "light_red"
        case .orange: return "orange"
        case .orangeLight: return "light_orange"
        case .yellow: return "yellow"
        case .yellowLight: return "light_yellow"
        case .green: return "green"
        case .greenLight: return "light_green"
        case .mint: return "mint"
        case .mintLight: return "light_mint"
        case .blue: return "blue"
        case .blueLight: return "light_blue"
        case .indigo: return "indigo"
        case .indigoLight: return "light_indigo"
        case .purple: return "purple"
        case .purpleLight: return "light_purple"
        case .pink: return "pink"
        case .pinkLight: return "light_pink"
        case .brown: return "brown"
        case .brownLight: return "light_brown"
        case .gray: return "gray"
        case .grayLight: return "light_gray"
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

    var markerImage: UIImage {
        switch self {
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
        case .indigo: return .markerIndigo
        case .indigoLight: return .markerIndigoLight
        case .purple: return .markerPurple
        case .purpleLight: return .markerPurpleLight
        case .pink: return .markerPink
        case .pinkLight: return .markerPinkLight
        case .brown: return .markerBrown
        case .brownLight: return .markerBrownLight
        case .gray: return .markerGray
        case .grayLight: return .markerGrayLight
        }
    }

}
