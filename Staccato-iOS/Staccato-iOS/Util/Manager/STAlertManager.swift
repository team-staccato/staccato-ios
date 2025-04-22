//
//  STAlertManager.swift
//  Staccato-iOS
//
//  Created by 김유림 on 4/23/25.
//

import Foundation

// MARK: - Alert Manager

@Observable
class STAlertManager {

    var isPresented = false
    private(set) var configuration: AlertConfiguration?

    func show(_ configuration: AlertConfiguration) {
        self.configuration = configuration
        self.isPresented = true
    }

    func hide() {
        isPresented = false
        configuration = nil
    }

}


// MARK: - Alert Configuration

/// - `primaryButton`: accent 컬러
/// - `secondaryButton`: 회색
/// - 두 버튼 모두 `dismiss 액션이 내장되어있습니다` (STAlertView - from line 70)
struct AlertConfiguration {
    let title: String?
    let message: String?
    let primaryButton: AlertButton?
    let secondaryButton: AlertButton?

    struct AlertButton {
        let title: String
        let action: (() -> Void)?
        
        static func button(_ title: String, _ action: (() -> Void)? = nil) -> AlertButton {
            AlertButton(title: title, action: action)
        }
    }

    static func alert(
        title: String?,
        message: String?,
        primaryButton: AlertButton?,
        secondaryButton: AlertButton? = nil
    ) -> AlertConfiguration {
        AlertConfiguration(
            title: title,
            message: message,
            primaryButton: primaryButton,
            secondaryButton: secondaryButton
        )
    }

}


// MARK: - Alert Configuration Factory

extension AlertConfiguration {

    static func confirmCancelAlert(
        title: String?,
        message: String?,
        _ onConfirm: @escaping () -> Void
    ) -> AlertConfiguration {
        .alert(
            title: title,
            message: message,
            primaryButton: .button("확인", onConfirm),
            secondaryButton: .button("취소")
        )
    }

    static func confirmAlert(
        title: String?,
        message: String?,
        onConfirm: @escaping () -> Void
    ) -> AlertConfiguration {
        .alert(
            title: title,
            message: message,
            primaryButton: .button("확인", onConfirm)
        )
    }

}
