//
//  StaccatoAlert.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/15/25.
//

import SwiftUI
import Observation

struct StaccatoAlertView: View {

    @Environment(StaccatoAlertManager.self) var alertManager

    var body: some View {
        ZStack {
            Color(.staccatoBlack).opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    alertManager.hide()
                }

            alertView
        }
        .background(TransparentViewRepresentable())
    }


    // MARK: - UI Components

    var alertView: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView
                .padding(.top, 20)
                .padding(.bottom, 36)
                .padding(.horizontal, 24)
            
            buttonHStack
            .padding(.bottom, 20)
            .padding(.horizontal, 24)
        }
        .background(.white)
        .clipShape(RoundedCornerShape(corners: .allCorners, radius: 10))
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }

    var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = alertManager.configuration?.title {
                Text(title)
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
            }
            
            if let message = alertManager.configuration?.message {
                Text(message)
                    .typography(.body2)
                    .foregroundStyle(.gray3)
            }
        }
    }

    var buttonHStack: some View {
        HStack(spacing: 6) {
            Spacer()
            if let secondaryButton = alertManager.configuration?.secondaryButton {
                Button(secondaryButton.title) {
                    withAnimation {
                        alertManager.hide()
                        secondaryButton.action?()
                    }
                }
                .buttonStyle(.staccatoFilled(verticalPadding: 10, foregroundColor: .gray4, backgroundColor: .gray1))
                .frame(width: 88)
            }
            
            if let primaryButton = alertManager.configuration?.primaryButton {
                Button(primaryButton.title) {
                    withAnimation {
                        alertManager.hide()
                        primaryButton.action?()
                    }
                }
                .buttonStyle(.staccatoFilled(verticalPadding: 10))
                .frame(width: 88)
            }
        }
    }

}
