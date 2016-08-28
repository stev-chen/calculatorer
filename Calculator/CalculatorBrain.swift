//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Steven Chen on 2016-07-02.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    func setOperand(operand: Double) {
        accumulator = operand
    }
    var currentHistory: String = " "
    
    private func forTrailingZero(dblVar: Double) -> String{
        let strVar = String(format: "%.10g", dblVar)
        return strVar
    }

    
    /*var description: String{
        get{
            
        }
    }
    */
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "x²" : Operation.UnaryOperation({$0 * $0}),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "log₁₀x":
            Operation.UnaryOperation({log10($0)}),
        "+/−" : Operation.UnaryOperation({0 - $0}),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "xʸ": Operation.BinaryOperation({pow($0, $1)}),
        "=" : Operation.Equals,
        "C" : Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
        case Clear
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                if symbol.rangeOfString("x") != nil{
                    currentHistory = symbol.stringByReplacingOccurrencesOfString("x", withString: forTrailingZero(accumulator))
                }
                else if symbol != "+/−"{
                    currentHistory = "\(symbol) \(forTrailingZero(accumulator))"
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, symbol: symbol)
            case .Equals:
                if pending == nil{
                    currentHistory = forTrailingZero(accumulator)
                }
                executePendingBinaryOperation()
            case .Clear:
                accumulator = 0
                pending = nil
                currentHistory = " "
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil{
            currentHistory = "\(forTrailingZero(pending!.firstOperand)) \(pending!.symbol) \(forTrailingZero(accumulator))"
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo{
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
        var symbol: String
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}