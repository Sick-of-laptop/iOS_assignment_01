import SwiftUI

struct ContentView: View {
    @State private var weight: String = "" // User's weight
    @State private var height: String = "" // User's height
    @State private var bmi: Double? = nil // Calculated BMI
    @State private var bmiCategory: String = "Enter your details" // Category text
    @State private var showCalculation = false // Control for showing BMI calculation form

    var body: some View {
        VStack {
            // Top Section with BMI and Progress Bar
            VStack {
                Text("BMI Calculator")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                // Show BMI Category and Value
                if let bmiValue = bmi {
                    Text("Your BMI is \(String(format: "%.2f", bmiValue))")
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    Text(bmiCategory)
                        .font(.title3)
                        .foregroundColor(bmiCategoryColor())
                        .padding(.top)
                    
                    // Progress Bar (Shows the BMI visually)
                    ProgressBar(bmi: bmiValue)
                        .frame(height: 20)
                        .padding()
                } else {
                    Text(bmiCategory)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
            }
            .padding()
            
            Spacer()
            
            // Button to toggle between BMI result and input fields
            Button(action: {
                showCalculation.toggle()
            }) {
                Text(showCalculation ? "Back to Result" : "Enter Your Details")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.title2)
            }
            
            if showCalculation {
                // BMI Calculation Form
                VStack {
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        .padding(.bottom)

                    TextField("Height (m)", text: $height)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                        .padding(.bottom)

                    Button(action: calculateBMI) {
                        Text("Calculate BMI")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            
            Spacer()
        }
    }
    
    // BMI Calculation Method
    func calculateBMI() {
        guard let weightValue = Double(weight), let heightValue = Double(height), heightValue > 0 else {
            return // Invalid input, do nothing
        }
        
        bmi = weightValue / (heightValue * heightValue)
        determineBMICategory()
    }
    
    // Determine the BMI category
    func determineBMICategory() {
        if let bmiValue = bmi {
            switch bmiValue {
            case ..<18.5:
                bmiCategory = "Underweight"
            case 18.5..<24.9:
                bmiCategory = "Normal weight"
            case 25..<29.9:
                bmiCategory = "Overweight"
            default:
                bmiCategory = "Obesity"
            }
        }
    }
    
    // Return color based on BMI category
    func bmiCategoryColor() -> Color {
        guard let bmiValue = bmi else { return .gray }
        
        switch bmiValue {
        case ..<18.5:
            return .blue
        case 18.5..<24.9:
            return .green
        case 25..<29.9:
            return .yellow
        default:
            return .red
        }
    }
}

// Progress Bar for BMI Visualization
struct ProgressBar: View {
    var bmi: Double
    
    var body: some View {
        let progress: Double
        if bmi < 18.5 {
            progress = bmi / 18.5
        } else if bmi < 24.9 {
            progress = (bmi - 18.5) / 6.4
        } else if bmi < 29.9 {
            progress = (bmi - 24.9) / 5.0
        } else {
            progress = (bmi - 29.9) / 10.0
        }
        
        return ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Rectangle()
                .fill(bmiBarColor())
                .cornerRadius(10)
                .frame(width: CGFloat(min(progress, 1.0)) * UIScreen.main.bounds.width)
        }
        .frame(maxWidth: .infinity)
    }
    
    // Return color based on BMI for progress bar
    func bmiBarColor() -> Color {
        if bmi < 18.5 {
            return .blue
        } else if bmi < 24.9 {
            return .green
        } else if bmi < 29.9 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
