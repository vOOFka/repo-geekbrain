//
//  AddQuestionViewController.swift
//  MillionVS
//
//  Created by Home on 08.12.2021.
//

import UIKit

class AddQuestionViewController: UIViewController {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var correctAnswerdTextField: UITextField!
    @IBOutlet weak var wrongAnswerdOneTextField: UITextField!
    @IBOutlet weak var wrongAnswerdTwoTextField: UITextField!
    @IBOutlet weak var wrongAnswerdThreeTextField: UITextField!
    @IBOutlet weak var AppendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapAppendButton(_ sender: UIButton) {
        
    }
}
