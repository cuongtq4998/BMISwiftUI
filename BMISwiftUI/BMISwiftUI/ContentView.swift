//
//  ContentView.swift
//  BMISwiftUI
//
//  Created by cuong tran on 27/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var weightText: String = "85"
    @State private var heightText: String = "1.85"
    @State private var bmi: Double = 0
    @State private var classification: String = ""
    @State private var categoryHightlight: ErrorCategory?
    @State private var isHidden: Bool = true
    
    enum ValidationError: Error, LocalizedError {
        case invalidWeight
        case invalidHeight
        case invalidBMI
        
        var errorDescription: String? {
            switch self {
            case .invalidWeight:
                return "Weight must be a number(e.g. 85)"
            case .invalidHeight:
                return "Height must be a number(e.g. 1.85)"
            case .invalidBMI:
                return "BMI must be a number(e.g. 25.8)"
            }
        }
    }
    
    struct ErrorCategory {
        let title: String
        let message: String
    }
    
    var body: some View {
        VStack {
            Text("BMI Caculator")
                .font(.largeTitle)
            
            TextField("Enter Weight (in kilograms)", text: $weightText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black, width: 1)
            
            TextField("Enter Height (in meters)", text: $heightText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black, width: 1)
            
            Button("Calculate BMI:\(bmi, specifier: "%.1f")") {
                do {
                    bmi = try calculateBMI()
                    isHidden = true
                } catch {
                    categoryHightlight = ErrorCategory(
                        title: "OMG 😱: ",
                        message: error.localizedDescription
                    )
                    isHidden = false
                }
            }.background(Color.orange)
                .safeAreaPadding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            
            if !isHidden {
                if let categoryHightlight = categoryHightlight {
                    Group {
                        Text(categoryHightlight.title)
                            .foregroundStyle(.gray)
                            .bold()
                        Text(categoryHightlight.message)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .italic()
                    }
                }
            }
        }
        .padding()
    }
    
    func calculateBMI() throws -> Double {
        guard let weight = Double(weightText) else {
            throw ValidationError.invalidWeight
        }
        
        guard let height = Double(heightText) else {
            throw ValidationError.invalidHeight
        }
        
        let bmi = weight / (height * height)
        if bmi.isNaN {
            throw ValidationError.invalidBMI
        }
        
        return bmi
    }
}

#Preview {
    ContentView()
}
