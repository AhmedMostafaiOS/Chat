//
//  Chat.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import Foundation
struct Chat:Decodable {
    var to_Id: String?
    var text: String?
    var ReciverUserImage: String?
    var SenderUserImage: String?

    var timestamp: Double?
    var sender_Id: String?
}
