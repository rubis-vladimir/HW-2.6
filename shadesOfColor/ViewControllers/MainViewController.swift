//
//  MainViewController.swift
//  shadesOfColor
//
//  Created by Владимир Рубис on 09.06.2021.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setColor(_ color: UIColor)
}

class MainViewController: UIViewController {
    
//    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingVC = segue.destination as! SettingsViewController
        settingVC.delegate = self
        settingVC.viewColor = view.backgroundColor
    }
}

// MARK: - ColorDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
