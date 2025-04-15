//
//  StaccatoAlert.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/15/25.
//

import SwiftUI

struct StaccatoAlertView<T: View>: View {

    @Environment(\.dismiss) private var dismiss

    let title: String?
    let message: String?
    @Binding var isPresented: Bool
    let buttons: T

    init(
        _ title: String?,
        message: String?,
        isPresented: Binding<Bool>,
        @ViewBuilder buttons: () -> T
    ) {
        self.title = title
        self.message = message
        self._isPresented = isPresented
        self.buttons = buttons()
    }

    var body: some View {
        ZStack {
            Color(red: 0.133, green: 0.133, blue: 0.133)
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            alertView
        }
        .background(TransparentViewRepresentable())

    }

    var titleView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title = title {
                Text(title)
                    .typography(.title2)
                    .foregroundStyle(.staccatoBlack)
            }
            
            if let message = message {
                Text(message)
                    .typography(.body2)
                    .foregroundStyle(.gray3)
            }
        }
    }

    var alertView: some View {
        VStack(alignment: .leading) {
            titleView
                .padding(.top, 20)
                .padding(.bottom, 36)
                .padding(.horizontal, 24)
            
            HStack(spacing: 6) {
                Spacer()
                buttons
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 24)
        }
        .background(.white)
        .clipShape(RoundedCornerShape(corners: .allCorners, radius: 10))
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }

}


// MARK: - Ex+View

extension View {

    func staccatoAlert<T: View>(
        _ title: String? = nil,
        message: String? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder buttons: @escaping () -> T
    ) -> some View {
        self
            .fullScreenCover(isPresented: isPresented) {
                StaccatoAlertView(title, message: message, isPresented: isPresented, buttons: buttons)
            }
    }

}
