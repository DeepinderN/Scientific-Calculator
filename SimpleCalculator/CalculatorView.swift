//
//  CalculatorView.swift
//  SimpleCalculator
//
//  Created by Deepinder on 7/25/25.
//

import SwiftUI

struct CalculatorView: View {
    @State private var expression: String = ""
    @State private var display: String = "0"
    
    // All buttons, including scientific ones
    private let buttons: [[String]] = [
        ["sin", "cos", "tan", "√", "C"],
        ["7", "8", "9", "/", "%"],
        ["4", "5", "6", "*", "^"],
        ["1", "2", "3", "-", "π"],
        ["0", ".", "=", "+", "⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // Display
            Text(display)
                .font(.system(size: 48))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            
            // Button grid
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { label in
                        Button(action: { tap(label) }) {
                            Text(label)
                                .font(.system(size: 24))
                                .frame(width: buttonSize(label), height: buttonSize(label))
                                .background(buttonColor(label))
                                .foregroundColor(.white)
                                .cornerRadius(buttonSize(label) / 2)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: – Button Logic
    
    private func tap(_ label: String) {
        switch label {
        case "C":
            expression = ""
            display = "0"
            
        case "⌫":
            if !expression.isEmpty {
                expression.removeLast()
                display = expression.isEmpty ? "0" : expression
            }
            
        case "=":
            evaluateExpression()
            
        case "π":
            append("pi")
            
        case "√":
            append("sqrt(")
            
        case "sin", "cos", "tan", "%", "^":
            append(label + "(")
            
        default:
            append(label)
        }
    }
    
    private func append(_ str: String) {
        expression += str
        display = expression
    }
    
    private func evaluateExpression() {
        // Replace our symbols with NSExpression-friendly ones
        let expr = expression
            .replacingOccurrences(of: "%", with: "/100")
            .replacingOccurrences(of: "^", with: "**")
        
        let nsExpr = NSExpression(format: expr)
        if let result = nsExpr.expressionValue(with: nil, context: nil) as? NSNumber {
            display = format(result.doubleValue)
            expression = String(result.doubleValue)
        } else {
            display = "Error"
        }
    }
    
    private func format(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(value)
    }
    
    // MARK: – Layout Helpers
    
    private func buttonSize(_ label: String) -> CGFloat {
        let totalSpacing = (buttons.first!.count + 1) * 12
        return (UIScreen.main.bounds.width - CGFloat(totalSpacing)) / CGFloat(buttons.first!.count)
    }
    
    private func buttonColor(_ label: String) -> Color {
        if ["=", "+", "-", "*", "/", "^"].contains(label) {
            return .orange
        } else if ["C", "⌫"].contains(label) {
            return .gray
        } else if ["sin", "cos", "tan", "√", "%", "π"].contains(label) {
            return .blue
        } else {
            return .secondary
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
