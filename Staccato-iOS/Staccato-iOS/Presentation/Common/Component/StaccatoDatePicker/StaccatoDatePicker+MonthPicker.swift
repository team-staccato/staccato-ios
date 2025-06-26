//
//  StaccatoDatePicker+MonthPicker.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/4/25.
//

import SwiftUI

extension StaccatoDatePicker {
    struct MonthPicker: UIViewRepresentable {
        @Binding var selectedDate: Date

        func makeUIView(context: Context) -> UIDatePicker {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .yearAndMonth
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.locale = Locale(identifier: "ko_KR")

            datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)

            return datePicker
        }

        func updateUIView(_ uiView: UIDatePicker, context: Context) {

        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject {
            var parent: MonthPicker

            init(_ parent: MonthPicker) {
                self.parent = parent
            }

            @objc func dateChanged(_ sender: UIDatePicker) {
                parent.selectedDate = sender.date
            }
        }
    }
}
