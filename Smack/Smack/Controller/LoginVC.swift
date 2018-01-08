//
//  LoginVC.swift
//  Smack
//
//  Created by Jordan Vacca on 04/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closePressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any)
    {
      performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
