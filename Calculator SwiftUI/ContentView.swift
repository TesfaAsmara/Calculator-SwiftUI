//
//  ContentView.swift
//  Calculator SwiftUI
//
//  Created by Tesfa Asmara on 11/21/19.
//  Copyright © 2019 Tesfa Asmara. All rights reserved.
//

import SwiftUI
//In the SceneDelegate, I added "environmentObject" modifier to make display and userIsInTheMiddleOfTyping available to other views by creating a variable var calculatorViewModel = CalculatorViewModel() and attaching .environmentObject(calculatorViewModel) to ContentView(), so that now I can refer to display and userIsInTheMiddleOfTyping from the calculatorVM

class CalculatorViewModel: ObservableObject { //ObservableObject binds the data model to a view
    @Published var display = "0"
    @Published var userIsInTheMiddleOfTyping = false //keeps track of when the user is in the middle of typing
    
    var displayValue: Double { //Allows me to avoid having to constantly convert between Doubles and String
        get {
            return Double(display)!
        }
        set {
            display = String(newValue)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel //So that I can refer to display and userIsInTheMiddleOfTyping from the calculatorVM
    @State var brain = CalculatorBrain()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 12) {
                Spacer()
                Text(calculatorVM.display)
                    .font(.system(size: 100))// attribute modifers for the display screen
                    .foregroundColor(.white)
                    .padding(.all)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.leading)
                    .padding(.trailing)
                VStack(spacing: 12) { //One big framing V-stack for the entire screen
                    UnarySymbols(brain: $brain)
                    HStack(spacing: 12) {
                        Digits() //extracted subview containing the creation of the rows of buttons
                        BinarySymbols(brain: $brain)
                    }
                }
            }
        }
    }
}

struct BinarySymbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain: CalculatorBrain
    
    let symbols = ["+", "−", "÷", "×"]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(symbols, id: \.self) { mathematicalSymbol in
                Button(mathematicalSymbol, action: {
                    self.calculatorVM.userIsInTheMiddleOfTyping = false
                    self.brain.setOperand(self.calculatorVM.displayValue)
                    self.brain.performOperation(mathematicalSymbol)
                    if let result = self.brain.result { //Get the result and display it
                        self.calculatorVM.displayValue = result
                    }
                })
                    .font(.system(size: 24))// Button attribute modifiers
                    .padding(.all, 35)
                    .foregroundColor(.white)
                        .background(Color.orange)
                    .cornerRadius(100)
                    
            }
        }
    }
}

struct UnarySymbols: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    @Binding var brain: CalculatorBrain
    
    let symbols = [ "℀","%","±","="]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(symbols, id: \.self) { mathematicalSymbol in
                Button(mathematicalSymbol, action: {
                    self.calculatorVM.userIsInTheMiddleOfTyping = false
                    self.brain.setOperand(self.calculatorVM.displayValue)//When an operation is clicked, save the operand, then perform te operation on the operand
                    self.brain.performOperation(mathematicalSymbol)
                    if let result = self.brain.result { //Get the result and display it
                        self.calculatorVM.displayValue = result
                    }
                })
                    .font(.system(size: 24))//Button attribute modifiers
                    .foregroundColor(.white)
                    .padding(.all, 35)
                    .background(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .cornerRadius(100)
            }
        }
    }
}

struct Digits: View {
    @EnvironmentObject var calculatorVM: CalculatorViewModel
    
    let digits = [["7", "8", "9"],
                  ["4", "5", "6"],
                  ["1", "2", "3"],
                  ["0", "."]]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(digits, id: \.self) { rowDigits in
                HStack(spacing: 12) { //Places rows in individual H-Stacks
                    ForEach(rowDigits, id: \.self) { digit in
                        Button("\(digit)", action: {
                            if self.calculatorVM.userIsInTheMiddleOfTyping { //When the user is in the middle of typing, append the digit, else just display the digit pressed
                                self.calculatorVM.display = self.calculatorVM.display + "\(digit)"
                            } else {
                                self.calculatorVM.display = "\(digit)"
                                self.calculatorVM.userIsInTheMiddleOfTyping = true
                            }
                        })
                            .font(.system(size: 24)) //Button attribute modifiers
                            .foregroundColor(.white)
                            .padding(.all, 35)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(100)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CalculatorViewModel())
    }
}

