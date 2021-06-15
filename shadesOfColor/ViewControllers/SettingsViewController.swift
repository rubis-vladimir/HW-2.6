//
//  SettingsViewController.swift
//  shadesOfColor
//
//  Created by Владимир Рубис on 20.05.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var viewForColorMix: BorderView!
    
    @IBOutlet var saturatedOfColor: [UILabel]!
    @IBOutlet var saturatedOfColorTF: [UITextField]!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var sliderAlpha: UISlider!
    @IBOutlet var sliders: [UISlider]!
    
    @IBOutlet weak var imageSubstrate: UIImageView!
    
    // MARK: - Public Properties
    var delegate: SettingsViewControllerDelegate!
    var viewColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageSubstrate.layer.cornerRadius = 30
        viewForColorMix.backgroundColor = viewColor
        
        setSliders()
        setValue()
    }
    
    // MARK: - IB Actions
    @IBAction func rgbSlider(_ sender: UISlider) {
        setValue()
        setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate?.setColor(viewForColorMix.backgroundColor ?? .white)
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension SettingsViewController {
    
    private func setColor() {
        viewForColorMix.backgroundColor = UIColor(
            red: CGFloat(sliderRed.value),
            green: CGFloat(sliderGreen.value),
            blue: CGFloat(sliderBlue.value),
            alpha: CGFloat(sliderAlpha.value)
        )
    }
    
    private func setValue() {
        for index in 0..<sliders.count {
            saturatedOfColor[index].text = string(from: sliders[index])
            saturatedOfColorTF[index].text = string(from: sliders[index])
        }
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: viewColor)
        
        sliderRed.value = Float(ciColor.red)
        sliderGreen.value = Float(ciColor.green)
        sliderBlue.value = Float(ciColor.blue)
        sliderAlpha.value = Float(ciColor.alpha)
    }
    
    // Значения RGB
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            switch textField {
            case saturatedOfColorTF[0]:
                sliderRed.setValue(currentValue, animated: true)
                setValue()
            case saturatedOfColorTF[1]:
                sliderGreen.setValue(currentValue, animated: true)
                setValue()
            case saturatedOfColorTF[2]:
                sliderBlue.setValue(currentValue, animated: true)
                setValue()
            default:
                sliderAlpha.setValue(currentValue, animated: true)
                setValue()
            }
            setColor()
            return
        }
        
        showAlert(title: "Wrong format!", message: "Please enter correct value")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title:"Done",
            style: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
}

// MARK: - Additional settings View

@IBDesignable class BorderView : UIView {
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
