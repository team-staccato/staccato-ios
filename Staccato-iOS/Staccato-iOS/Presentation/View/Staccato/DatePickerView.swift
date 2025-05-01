//
//  DatePickerView.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/24/25.
//

import SwiftUI

extension StaccatoEditorView {
    struct DatePickerView: View {
        @Binding var selectedDate: Date?

        @State private var year: Int
        @State private var month: Int
        @State private var day: Int
        @State private var hour: Int

        private let calendar: Calendar = Calendar.current

        private var yearRange: ClosedRange<Int> {
            guard let maximumYear = calendar.dateComponents(in: .current, from: .now).year else {
                return 1900...2025
            }
            return 1900...maximumYear
        }

        private var monthRange: ClosedRange<Int> {
            return 1...12
        }

        private var dayRange: ClosedRange<Int> {
            let selectedMonth = DateComponents(
                calendar: .current,
                timeZone: .current,
                year: self.year,
                month: self.month
            )

            guard let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth.date ?? .now) else { return 1...31 }
            let lastDayDate = monthInterval.end.addingTimeInterval(-1)

            guard let lastDay = calendar.dateComponents(in: .current, from: lastDayDate).day else { return 1...31 }

            return 1...lastDay
        }

        private var hourRange: ClosedRange<Int> {
            return 0...23
        }

        init(selectedDate: Binding<Date?>) {
            self.year = calendar.dateComponents(in: .current, from: .now).year ?? 2025
            self.month = calendar.dateComponents(in: .current, from: .now).month ?? 1
            self.day = calendar.dateComponents(in: .current, from: .now).day ?? 1
            self.hour = calendar.dateComponents(in: .current, from: .now).hour ?? 0
            self._selectedDate = selectedDate
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 36) {
                Text("일시를 선택해 주세요")
                    .foregroundStyle(.staccatoBlack)
                    .typography(.title2)
                    .padding(.top, 23)

                HStack(spacing: 0) {
                    Picker("", selection: $year) {
                        ForEach(yearRange, id: \.self) { year in
                            Text("\(year.description)")
                                .typography(.body1)
                                .tag(year)
                                .fixedSize(horizontal: false, vertical: true)

                        }
                    }
                    .pickerStyle(.wheel)

                    Text("년")

                    Picker("", selection: $month) {
                        ForEach(monthRange, id: \.self) { month in
                            Text("\(month.description)")
                                .typography(.body1)
                                .tag(month)
                        }
                    }
                    .pickerStyle(.wheel)

                    Text("월")

                    Picker("", selection: $day) {
                        ForEach(dayRange, id: \.self) { day in
                            Text("\(day.description)")
                                .tag(day)
                        }
                    }
                    .pickerStyle(.wheel)

                    Text("일")

                    Picker("", selection: $hour) {
                        ForEach(hourRange, id: \.self) { hour in
                            Text("\(hour.description)")
                                .typography(.body1)
                                .tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)

                    Text("시")
                }
                .typography(.body1)
                .foregroundStyle(.gray4)
                .padding(.bottom, 60)
            }
            .padding(.horizontal)

            .onChange(of: year, validateComponents)
            .onChange(of: month, validateComponents)
            .onChange(of: day, validateComponents)
            .onChange(of: hour, validateComponents)
        }

        private func validateComponents() {
            guard let date = dateByComponents(year, month, day, hour) else { return }

            selectedDate = date
        }

        private func dateByComponents(_ year: Int, _ month: Int, _ day: Int, _ hour: Int) -> Date? {
            var calendar = Calendar.autoupdatingCurrent
            calendar.timeZone = TimeZone.current

            let components = DateComponents(
                calendar: calendar,
                timeZone: .current,
                year: year,
                month: month,
                day: day,
                hour: hour
            )

            return calendar.date(from: components)
        }
    }
}

#Preview {
    StaccatoEditorView.DatePickerView(selectedDate: .constant(.now))
}
