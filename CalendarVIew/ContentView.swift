//
//  ContentView.swift
//  CalendarVIew
//
//  Created by Muhammad Zeeshan on 2022-08-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentDate: Date = Date()
    @State private var isCalendarActive: Bool = false
    @State private var availablilityDate: Date = Date()
    @State var disableDatesArr: [String] = ["2022-08-15", "2022-08-18", "2022-08-25","2022-07-29"]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "calendar")
                    Text("Check Availability Date")
                        .bold()
                }
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8.0)
                .onTapGesture {
                    withAnimation {
                        isCalendarActive = true
                    }
                }
                Text("Selected Date = \(currentDate)")
            }
            if isCalendarActive {
                CalendarView(currentDate: $currentDate,
                             isCalendarActive: $isCalendarActive,
                             disableDatesArr: $disableDatesArr)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
