//
//  Helper.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import Foundation
class Helper {
    static var currentUser:User? {
        get {
            var user:User?
            if let userArr  = UserDefaults.standard.value(forKey: "currentUser") as? [String:Any]   {
                do {
                    let data = try JSONSerialization.data(withJSONObject: userArr, options: .prettyPrinted)
                    let decode = JSONDecoder.init()
                    user = try decode.decode(User.self, from: data)
                    
                    return user!
                }catch(let err){
                    print(err)
                }
            }
            return user
        }
        set{
            let defaults = UserDefaults.standard
            defaults.set(newValue?.toDict(), forKey: "currentUser")
            defaults.synchronize()
        }
    }

}
