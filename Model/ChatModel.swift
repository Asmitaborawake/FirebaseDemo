//
//  ChatModel.swift
//  FirebaseDemo
//
//  Created by Asmita Borawake on 24/12/21.
//

import Foundation
    
import UIKit
class ChatModle{
    var name : String?
    var text : String?
    var profileImgUrl : String?
    
    
    init(name: String, text : String, profileImgUrl: String)
    {
        self.name = name
        self.text = text
        self.profileImgUrl = profileImgUrl
        
    }
}
