//
//  Channel.swift
//  Smack
//
//  Created by Jordan Vacca on 15/01/2018.
//  Copyright © 2018 Jordan Vacca. All rights reserved.
//

import Foundation

struct Channel : Decodable
{
    public private(set) var _id: String!
    public private(set) var description : String!
    public private(set) var name: String!
    public private(set) var __v: Int?
}
