//
//  AddChannelVC.swift
//  Smack
//
//  Created by Jordan Vacca on 17/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var chanDesc: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    
    @IBAction func createChannelPressed(_ sender: Any)
    {
        guard let channelName = nameTxt.text, nameTxt.text != "" else {return}
        guard let channelDesc = chanDesc.text, chanDesc.text != "" else {return}
        SocketService.instance.addChanel(channelName: channelName, channelDescription: channelDesc) { (succes) in
            if succes {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func clossModalPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView()
    {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
        chanDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : smackPurplePlaceholder])
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
