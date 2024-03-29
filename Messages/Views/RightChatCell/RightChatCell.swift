//
//  RightChatCell.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import UIKit
import SDWebImage
class RightChatCell: UITableViewCell {
    @IBOutlet weak var chatLBL: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    //MARK: - View life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureRightChatCell(chat: Chat)
    {
       
        chatLBL.text = chat.text ?? ""
        if let url = URL(string: chat.ReciverUserImage ?? "") {
             userImage.sd_setImage(with: url, completed: nil)
        }
       
        
    }

}
