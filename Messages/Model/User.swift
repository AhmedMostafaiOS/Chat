//
//  User.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import Foundation
struct User:Decodable {
    let id:String
    let name:String
    let image:String
    let status:Bool
    let email:String
    func toAnyObject() -> Any {
        return ["id":id, "name":name,"image":image,"status":status,"email":email] as Any
    }
    func toDict() -> [String:Any] {
        return ["id":id, "name":name,"image":image,"status":status,"email":email] as [String:Any]
    }
}
