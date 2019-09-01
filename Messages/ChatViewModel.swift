//
//  ChatViewModel.swift
//  ChatBubble
//
//  Created by Rahul kr on 06/06/18.
//

import Foundation
import Firebase
import ProgressHUD
protocol ChatViewDelegate
{
    func onItemAdded() -> ()
}

protocol ChatViewPresentable
{
    var newchat: String? {get}
}

class ChatViewModel: ChatViewPresentable {
    var dbChat:DatabaseReference!
    var dbConverstion:DatabaseReference!
    var user:User?
    var chats: [Chat] = []
    var newchat: String?
    weak var viewc: ChatViewControllerDelegate?
    
    
    init(view: ChatViewControllerDelegate , recvier:User) {
        dbChat = Database.database().reference(withPath: "Chat")
        dbConverstion = Database.database().reference(withPath: "Coversition")
        viewc = view
        self.user = recvier
        chats = []
        fetchChat()
    }
    func fetchChat()  {
        ProgressHUD.show("Waiting...", interaction: false)
        dbChat.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            ProgressHUD.dismiss()

            if (dataSnapshot.exists()) {
                for child in dataSnapshot.children {
                    guard let value = child as? [String: Any] else { return }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        let chat = try JSONDecoder().decode(Chat.self, from: jsonData)
                        self.chats.append(chat)
                    } catch let error {
                        print(error)
                    }
                }
                self.viewc?.didNewChatMessagesRecieved()
                
            }
        })
        dbChat.observe(.childAdded, with: { (dataSnapshot) in
            ProgressHUD.dismiss()

            if (dataSnapshot.exists()) {
                guard let value =  dataSnapshot.value as? [String: Any] else { return }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let chat = try JSONDecoder().decode(Chat.self, from: jsonData)
                    self.chats.append(chat)
                    self.viewc?.didNewChatMessagesRecieved()
                } catch let error {
                    print(error)
                }
            }
 
    })
    }
}
extension ChatViewModel {
    func handleSend(message:String) {
        let properties = ["text":message]
        sendMessageWithProperties(properties: properties)
    }
    private func sendMessageWithProperties(properties: [String: Any]) {
        let ref = dbChat!
        let childRef = ref.childByAutoId()
        let toId = user?.id
        let senderId = Auth.auth().currentUser!.uid
        let timestamp = (NSDate().timeIntervalSince1970)
        var values: [String: Any] = ["to_Id": toId ?? "","ReciverUserImage": self.user?.image ?? "","SenderUserImage": Helper.currentUser?.image ?? "", "sender_Id": senderId, "timestamp": timestamp] as [String : Any]
        properties.forEach({values[$0.0] = $0.1})
        childRef.updateChildValues(values) { (error, ref ) in
            if error != nil {
                print(error ?? "error updating child values")
                return
            }
            let userMessagesRef = self.dbChat?.child("user-messages").child(senderId).child(toId!)
            let messageId = childRef.key
            userMessagesRef?.updateChildValues([messageId: 1])
            let recipientUserMessagesRef = self.dbChat?.child("user-messages").child(toId!).child(senderId)
            recipientUserMessagesRef?.updateChildValues([messageId: 1])
            
        }
    }
    
}

extension ChatViewModel: ChatViewDelegate
{
    func onItemAdded() {
        handleSend(message: newchat ?? "")
    
    }
}

