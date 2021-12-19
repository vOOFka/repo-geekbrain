//
//  SettingsViewController.swift
//  MillionVS
//
//  Created by Home on 07.12.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var difficultySegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultySegmentControl.selectedSegmentIndex = Game.shared.selectedDifficulty.rawValue
    }
    
    @IBAction func didSelectedDifficulty(_ sender: UISegmentedControl) {
        switch self.difficultySegmentControl.selectedSegmentIndex {
        case 0:
            Game.shared.selectedDifficulty = .easy
        case 1:
            Game.shared.selectedDifficulty = .medium
        default:
            Game.shared.selectedDifficulty = .easy
        }        
    }
}
