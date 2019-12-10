//
//  Constants.swift
//  RandomChat
//
//  Created by Ziping Huang on 12/5/19.
//  Copyright © 2019 Ziping Huang. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
