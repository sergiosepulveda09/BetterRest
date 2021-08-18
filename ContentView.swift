//
//  ContentView.swift
//  BetterRest
//
//  Created by Sergio Sepulveda on 2021-06-10.
//

import SwiftUI

struct ContentView: View {
    
    //Default wake up time so it doesn't use the current time
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    //Variables declaration
    @State private var wakeUp: Date = defaultWakeTime
    @State private var sleepAmount: Double = 8.0
    @State private var coffeeAmount: Int = 1
    var recommededTime: String {
        //Get the MLModel
        let model = SleepCalculator()
        
        //Get the time inputted by the user, it only gets the hour and minutes
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0 ) * 60
        
        //It is gonna do this if the catch doesn't find any error
        let prediction = try! model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
        
        //We do this to get the time- substracting the seconds of the desired time.
        let sleepTime = wakeUp - prediction.actualSleep
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let result = formatter.string(from: sleepTime)
        return result
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a Date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("\(Int(sleepAmount)) hours"))
                Text("Daily coffee intake")
                    .font(.headline)
//                Stepper(value: $coffeeAmount, in: 1...20) {
//                    if coffeeAmount == 1 {
//                        Text("\(coffeeAmount) cup")
//                    }
//                    else {
//                        Text("\(coffeeAmount) cups")
//                    }
//                }
                Picker("Coffe", selection: $coffeeAmount) {
                    ForEach(1..<21) { cups in
                        if cups == 1 {
                            Text("\(cups) cup")
                        }
                        else {
                            Text("\(cups) cups")
                        }
                    }
                }
                Section {
                    Text("Recommended time: ")
                        .font(.headline)
                    Text("\(recommededTime)")
                    
                    
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
