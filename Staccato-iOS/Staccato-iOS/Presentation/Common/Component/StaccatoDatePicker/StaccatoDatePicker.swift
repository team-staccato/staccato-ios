//
//  StaccatoDatePicker.swift
//  Staccato-iOS
//
//  Created by Gyunni on 1/21/25.
//

import SwiftUI

struct StaccatoDatePicker: View {
    @State var startDate: Date?
    @State var endDate: Date?
    @State var selectedMonth: Date = .now
    @State var isMonthPickerPresented = false

    @Binding var isDatePickerPresented: Bool
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?

    let calendarColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(titleText)
                .typography(.title1)
                .padding(.bottom, 40)

            selectMonthSection
                .padding(.bottom, 30)

            calendar
                .padding(.bottom, 30)

            HStack {
                Spacer()

                cancelButton
                    .padding(.trailing)

                confirmButton
            }
        }
        .padding(.horizontal, 20)

    }
}


#Preview {
    StaccatoDatePicker(isDatePickerPresented: .constant(false), selectedStartDate: .constant(.now), selectedEndDate: .constant(.now))
}

extension StaccatoDatePicker {
    private var titleText: String {
        guard let startDate else { return "날짜를 선택해주세요." }
        guard let endDate else { return "\(startDate.formattedAsMonthAndDayKR)~"}

        return "\(startDate.formattedAsMonthAndDayKR)~\(endDate.formattedAsMonthAndDayKR)"
    }

    private var selectMonthSection: some View {
        HStack {
            Button {
                isMonthPickerPresented = true
            } label: {
                HStack(spacing: 10) {
                    Text(selectedMonth.formattedAsYearAndMonth)

                    Image(systemName: "arrowtriangle.down.fill")
                        .typography(.body4)
                }
                .foregroundStyle(Color.staccatoBlack)
            }

            Spacer()

            HStack(spacing: 40) {
                Button {
                    guard let subtractMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) else { return }

                    selectedMonth = subtractMonth
                } label: {
                    Image(.chevronLeft)
                }

                Button {
                    guard let addMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) else { return }

                    selectedMonth = addMonth
                } label: {
                    Image(.chevronRight)
                }
            }
        }
        .sheet(isPresented: $isMonthPickerPresented) {
            MonthPicker(selectedDate: $selectedMonth)
                .presentationDetents([.fraction(0.3)])
        }
    }

    private var calendar: some View {
        LazyVGrid(columns: calendarColumns, spacing: 10) {
            weekdayRow
            calendarGrid
        }
    }

    private var confirmButton: some View {
        Button("확인", action: confirm)
    }

    private var cancelButton: some View {
        Button("취소", action: cancel)
    }
}

extension StaccatoDatePicker {
    private func confirm() {
        selectedStartDate = startDate
        selectedEndDate = endDate
        isDatePickerPresented = false
    }

    private func cancel() {
        isDatePickerPresented = false
    }
}
