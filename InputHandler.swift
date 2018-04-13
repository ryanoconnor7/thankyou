
import PlaygroundSupport
import UIKit

let public display = UIView(frame: CGRect(x: 10, y: 0, width: 400, height: 800))
display.backgroundColor = #colorLiteral(red: 0.925490200519562, green: 0.235294118523598, blue: 0.10196078568697, alpha: 1.0)
// Text Fields
let nameInput = UITextField(frame: CGRect(x: 8, y: 8, width: 200, height: 29))
nameInput.placeholder = "Name"
nameInput.borderStyle = .roundedRect
display.addSubview(nameInput)

let ageInput = UITextField(frame: CGRect(x: 8, y: 44, width: 200, height: 29))
ageInput.placeholder = "Birthday"
ageInput.borderStyle = .roundedRect
display.addSubview(ageInput)

// Output Label
let outputLabel = UILabel(frame: CGRect(x: 8, y: 60, width: 400, height: 100))
outputLabel.text = "Welcome!"
outputLabel.numberOfLines = 0
outputLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
display.addSubview(outputLabel)

// Class that handles input 
public class InputHander {
    init() {
        // init() is run when our InputHandler object is created. Here, we will add "targets" to our text fields so that they run a function whenever the text is changed.
        nameInput.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        
        ageInput.addTarget(self, action: #selector(ageChanged), for: .editingChanged)
        
        // Time to update bday countdown
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ageChanged), userInfo: nil, repeats: true)
    }
    
    @objc func nameChanged() {
        // handle change in name text field
        if nameInput.text! != "" {
            currentName = nameInput.text!
        } else {
            currentName = "{enter name}"
        }
        updateOutput()
    }
    
    @objc func ageChanged() { 
        // handle change in age text field, then calculate age in days 
        if ageInput.text! != "" {
            
            if let age = ageInput.text {
                // Text is a String
                
                // Now we need to validate the date input, making sure it is formatted correctly
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/d/yy"
                
                // Get Date object from text input  it may be nil, so unwrap
                if let date = dateFormatter.date(from: age) {
                    print(date)
                    let calender = Calendar(identifier: .gregorian)
                    let cal2 = Calendar(identifier: .gregorian)
                    let birthdayAge = calender.dateComponents([.year], from: date, to: Date.init()).year! + 1
                    
                    // making the birthday age look pretty. 17 → 17th
                    let ageFormatter = NumberFormatter()
                    ageFormatter.numberStyle = .ordinal
                    let ageString = ageFormatter.string(from: NSNumber(value: birthdayAge))!
                    
                    let currentYear = calender.dateComponents([.year], from: Date.init()).year!
                    var bdayComps = calender.dateComponents([.day,.month], from: date)
                    bdayComps.year = currentYear
                    
                    var bdayDate = calender.date(from: bdayComps)!
                    
                    if bdayDate < Date.init() {
                        bdayComps.year! += 1
                        bdayDate = calender.date(from: bdayComps)!
                    }
                    
                    let duration = bdayDate.timeIntervalSince1970 - Date.init().timeIntervalSince1970
                    
                    let bdayFormatter = DateComponentsFormatter()
                    bdayFormatter.unitsStyle = .short
                    bdayFormatter.allowedUnits = [
                        .day,.hour,.minute,.second]
                    bdayFormatter.zeroFormattingBehavior = .dropAll
                    
                    let formattedDuration = bdayFormatter.string(from: duration)!
                    
                    currentAge = "Your \(ageString) birthday is in \(formattedDuration)."
                    updateOutput()
 
                } else {
                    // handle for no date
                }
            } else {
                // Text is not a date
                outputLabel.text = "Please enter a birthday in the format: 1/1/18."
            }
        } else {
            // Age blank
            currentAge = "{enter birthday}"
            updateOutput()
        }
        
    }
    
    var currentName = "{enter name}"
    var currentAge = "{enter age}"
    
    func updateOutput() {
        outputLabel.text = "Hi \(currentName)! \(currentAge)"
    }
    
    
}

