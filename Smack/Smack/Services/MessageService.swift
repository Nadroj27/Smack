//
//  MessageService.swift
//  Smack
//
//  Created by Jordan Vacca on 15/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService
{
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    var messages = [Message]()
    
    
    func findAllChannel(completion: @escaping CompletionHandler)
    {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                guard let data = response.data else {return}
                do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                } catch let error {
                    debugPrint(error as Any)
                }
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel (channelId : String, completion : @escaping CompletionHandler)
    {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                do
                {
                self.clearMessages()
                guard let data = response.data else {return}
                let json  = try JSON(data: data).array
                    for item in json! {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                }
                catch {
                    debugPrint(error)
                }
    
                    print(self.messages)
                    completion(true)
            }
            else
            {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages()
    {
        messages.removeAll()
    }
    
    func clearChannels()
    {
        channels.removeAll()
    }
    
}
