//
//  ContentView.swift
//  CalendarVIew
//
//  Created by Muhammad Zeeshan on 2022-08-09.
//

import SwiftUI

struct CalendarView: View {
    
    @Binding var currentDate: Date
    @State var monthCurrent: Int = 0
    @Binding var isCalendarActive: Bool
    @Binding var disableDatesArr: [String]

    var calendar = Calendar.current
    
    let days: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    withAnimation {
                        monthCurrent -= 1
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.black.opacity(0.5))
                })
               
                Spacer()
                Text(extraDate()[2] + " " + extraDate()[1])
                    .font(.system(size: 24))
                    .bold()
                Spacer()
            }
            .padding()
            HStack(spacing: 0) {
                ForEach(days, id: \.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 24) 
            LazyVGrid(columns: columns, spacing: 48) {
                ForEach(extractDate()) { value in
                        CardView(value: value, disableDate: disableDatesArr)
                            .background(
                                Circle()
                                    .fill(Color.orange)
                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                    .frame(width: 64, height: 64, alignment: .center)
                            )
                            .onTapGesture {
                                if !disableDatesArr.contains(dateFormate(date: value.date)) {
                                    currentDate = value.date
                                }
                            }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Text("Cancel").bold().onTapGesture {
                    withAnimation {
                        isCalendarActive = false
                    }
                }
                Spacer()
                Text("OK").bold().onTapGesture {
                    withAnimation {
                        isCalendarActive = false
                    }
                }
            }
            .font(.system(size: 20))
            .foregroundColor(.purple)
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .gray, radius: 8, x: -4, y: -2)
    }
    
    @ViewBuilder
    func CardView(value: DateValue, disableDate: [String]) -> some View {
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : disableDatesArr.contains(dateFormate(date: value.date)) ? .gray : .black)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.date(byAdding: .month, value: monthCurrent, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let currentMonth = getCurrentMonth()
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first!.date)
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
    func extraDate() -> [String] {
        let date = currentDate
        let month = calendar.component(.month, from: currentDate) - 1
        let year = calendar.component(.year, from: currentDate)
        return ["\(date)", "\(year)", calendar.monthSymbols[month]]
    }
    
    func dateFormate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let strDate = formatter.string(from: date)
        return strDate
    }
}

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
