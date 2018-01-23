//
//  ChatVC.swift
//  Smack
//
//  Created by Jordan Vacca on 04/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var messageTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @IBAction func sendMsgPressed(_ sender: Any)
    {
        if AuthService.instance.isLoggedIn
        {
            guard let channelId = MessageService.instance.selectedChannel?._id else {return}
            guard let message = messageTextBox.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (succes) in
                if succes {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                }
            })
        }
    }
    
    @objc func handleTap()
    {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification)
    {
        if AuthService.instance.isLoggedIn
        {
            onLoginGetMessages()
        }
        else
        {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    func updateWithChannel()
    {
       let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    @objc func channelSelected(_ notif: Notification)
    {
        updateWithChannel()
    }
    
    func onLoginGetMessages()
    {
        MessageService.instance.findAllChannel { (success) in
            if success
            {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }
                else
                {
                 self.channelNameLbl.text = "No channel yet !"
                }
            }
        }
    }
    
    func getMessages()
    {
        guard let channelId = MessageService.instance.selectedChannel?._id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (succes) in
            
        }
    }
}
