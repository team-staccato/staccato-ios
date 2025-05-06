//
//  StaccatoDatePicker+Calendar.swift
//  Staccato-iOS
//
//  Created by Gyunni on 2/4/25.
//

import SwiftUI

extension StaccatoDatePicker {
    private var monthDates: [Date?] {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month], from: selectedMonth)
        guard let firstOfMonth = calendar.date(from: components) else { return [] }

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let offset = weekday - 1
        let leadingEmptyDays = offset < 0 ? offset + 7 : offset

        guard let range = calendar.range(of: .day, in: .month, for: selectedMonth) else { return [] }

        var dates: [Date?] = Array(repeating: nil, count: leadingEmptyDays)
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: firstOfMonth) {
                dates.append(date)
            }
        }
        return dates
    }

    var weekdayRow: some View {
        ForEach(Weekday.allCases, id: \.self) { weekday in
            Text(weekday.localizedName)
                .foregroundStyle(Color.staccatoBlack)
                .frame(maxWidth: .infinity)
        }
    }

    var calendarGrid: some View {
        ForEach(Array(monthDates.enumerated()), id: \.offset) { index, date in
            if let date {
                Button {
                    selectDate(date)
                    print(date)
                } label: {
                    ZStack {
                        cellBackground(for: date)

                        Text("\(Calendar.current.component(.day, from: date))")
                            .foregroundStyle(isSelected(date) ? Color.staccatoWhite : Color.staccatoBlack)
                    }
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
            } else {
                Text("")
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
        }
    }

    private func cellBackground(for date: Date) -> some View {
        ZStack {
            if let startDate, let endDate {
                if startDate == date {
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                        Rectangle()
                            .fill(Color.accentColor.opacity(0.3))
                    }
                    Circle()
                        .fill(Color.accentColor)
                } else if endDate == date {
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.accentColor.opacity(0.3))
                        Rectangle()
                            .fill(Color.clear)
                    }
                    Circle()
                        .fill(Color.accentColor)
                } else if date > startDate && date < endDate {
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.3))
                } else {
                    Color.clear
                }
            } else {
                if date == startDate {
                    Circle()
                        .fill(Color.accentColor)
                } else {
                    Color.clear
                }
            }
        }
    }

    private func selectDate(_ date: Date) {
        if startDate != nil, endDate != nil {
            startDate = date
            endDate = nil
        } else if let startDate {
            if startDate >= date {
                self.startDate = date
                endDate = nil
            } else {
                endDate = date
            }
        } else {
            startDate = date
        }
    }

    private func isSelected(_ date: Date) -> Bool {
        if date == startDate || date == endDate {
            return true
        }

        return false
    }
}
