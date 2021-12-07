//
//  SettingsViewController.swift
//  MillionVS
//
//  Created by Home on 07.12.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var difficultySegmentControl: UISegmentedControl!
    
    private var game = Game.shared.selectedDifficulty
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didSelectedDifficulty(_ sender: UISegmentedControl) {
        switch self.difficultySegmentControl.selectedSegmentIndex {
        case 0:
            game = .easy
        case 1:
            game = .medium
        default:
            game = .easy
        }        
    }
}
