//
//  ChatViewController.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import UIKit
import Firebase
protocol ChatViewControllerDelegate: class {
    func didNewChatMessagesRecieved() -> ()
}
class ChatViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var chatTXTBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var chatTXT: UITextField!
    var recvier:User!
    var chatviewmodel:ChatViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitializers()
        navigationItem.title = "Chats"
        chatTable.register(LeftChatCell.self)
        chatTable.register(RightChatCell.self)
    }
}
    extension ChatViewController: KeyBoardNotificationDelegate,UITableViewDataSource,ChatViewControllerDelegate
    {
        
        //MARK: - Custom Accessors
        
        fileprivate func setUpInitializers()
        {
            KeyboardNotificationController.sharedKC.registerforKeyBoardNotification(delegate: self)
            addOnTapDismissKeyboard()
            chatviewmodel = ChatViewModel(view: self,recvier: recvier)
        }
        
        fileprivate func scrollToBottom(){
            DispatchQueue.main.async {
                if (self.chatviewmodel?.chats.count != 0) {
                let indexPath = IndexPath(row: (self.chatviewmodel?.chats.count)!-1, section: 0)
                self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
        
        fileprivate func addOnTapDismissKeyboard() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
            self.view.addGestureRecognizer(tapGesture)
            print("**************Table view didSelect maynot work!!!!!!!!!!!!!!!")
        }
        
        @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }
        
        fileprivate func addChat()
        {
            chatviewmodel?.newchat = chatTXT.text
            chatviewmodel?.onItemAdded()
            chatTXT.text = ""
        }
        
        //MARK: - ChatViewControllerDelegate
        
        func didNewChatMessagesRecieved() {
            chatTable.reloadData()
            scrollToBottom()
        }
        
        //MARK: - KeyBoardNotificationDelegate
        
        func didKeyBoardAppeared(keyboardHeight: CGFloat) {
            
            self.chatTXTBottomConstraint.constant = (keyboardHeight == 0) ? 0 : -keyboardHeight
            chatTable.reloadData()
            scrollToBottom()
        }
        
        
        //MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  self.chatviewmodel?.chats.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let chat:Chat = (chatviewmodel?.chats[indexPath.row])!
            if chat.sender_Id == Auth.auth().currentUser?.uid {
                let cell:RightChatCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureRightChatCell(chat: chat)
                return cell
            }
            let cell:LeftChatCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureLeftChatCell(chat:chat)
            return cell
        }

        @IBAction func sendChat(_ sender: UIButton)
        {
            (chatTXT.text?.isEmpty)! ? nil : addChat()
        }
}
