//
//  CalculatorBrain.swift
//  Calculator SwiftUI
//
//  Created by Tesfa Asmara on 11/21/19.
//  Copyright © 2019 Tesfa Asmara. All rights reserved.
//

import Foundation

//Added a comment for the purpose of the homework assignment.

func changeSign(operand: Double) -> Double { //changes sign
    return -operand
}

func percentage(operand: Double) -> Double { // gets percentage
    return operand/100
}

func clears(operand:Double) -> Double { // makes display = 0
    return 0
}

struct CalculatorBrain {
    
    private var accumulator: Double? //Accumulator is an internal variable that will hold the results of the calculations
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [ //extends the functionality of the CalculatorBrain by putting it in a lookup array.
        "%": Operation.unaryOperation(percentage),
        "±": Operation.unaryOperation(changeSign),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "−": Operation.binaryOperation({$0 - $1}),
        "=": Operation.equals,
        "℀": Operation.unaryOperation(clears)
    ]
    
    mutating func performOperation(_ symbol: String) { // performOperation is a function where all the calculation will take place. It will recieve the mathematical symbol and will calculate
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                break
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                break
            case .binaryOperation(let function):
                if accumulator != nil {
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() { //Save the 2 operands and performs the binary operation
        if pbo != nil && accumulator != nil {
            accumulator = pbo!.perform(with: accumulator!)
            pbo = nil
        }
    }
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) { //In order to perform operation, setOperand will give the needed operands to perform the operation to.
        accumulator = operand
    }
    
    var result: Double? { // This will return the result. Which we can get from the accumulator as it stores the results of the calculation.
        get {
            return accumulator
        }
    }
}
