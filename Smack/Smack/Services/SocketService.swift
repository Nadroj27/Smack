//
//  SocketService.swift
//  Smack
//
//  Created by Jordan Vacca on 22/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject
{
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addChanel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        manager.defaultSocket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let id = dataArray[2] as? String else { return }
            let newChannel = Channel(_id: id, description: channelDescription, name: channelName, __v: nil)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId : String, channelId : String, completion: @escaping CompletionHandler)
    {
        let user = UserDataService.instance
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
}
