//
//  ViewController.swift
//  Messages
//
//  Created by Abed Nayef Qasim on 8/31/19.
//  Copyright © 2019 Abed Nayef Qasim. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class HomeViewController: UIViewController {
    @IBOutlet weak var conversionTabelView: UITableView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    var db:DatabaseReference?

    var userList:[User] = [] {
        didSet {
            userCollectionView.reloadData()
        }
    }
    var conversionList:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.register(UserCell.self)
        conversionTabelView.register(ChatCell.self)
        let logout:UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-sign-out-50"), style: .plain, target: self, action: #selector(logoutMessage))
        self.navigationItem.rightBarButtonItem = logout
        db = Database.database().reference(withPath: "Users")
        fetchUsers()
        
    }
    @objc func logoutMessage(){
        db?.child(Auth.auth().currentUser?.uid ?? "").child("status").setValue(false)
      try! Auth.auth().signOut()
      Helper.currentUser = nil
      showLogin()
    }
    func fetchUsers() {
        db?.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            if (dataSnapshot.exists()) {
                for child in dataSnapshot.children {
                    guard let value = child as? [String: Any] else { return }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        let user = try JSONDecoder().decode(User.self, from: jsonData)
                        if user.status {
                            self.changeUserList(user)
                            self.userList.append(user)
                        }else {
                            self.changeUserList(user)
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        })
        db?.observe(.childAdded, with: { (dataSnapshot) in
            if (dataSnapshot.exists()) {
                    guard let value =  dataSnapshot.value as? [String: Any] else { return }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                        let user = try JSONDecoder().decode(User.self, from: jsonData)
                        if user.status {
                            self.changeUserList(user)
                            self.userList.append(user)
                        }else {
                            self.changeUserList(user)
                        }
                    } catch let error {
                        print(error)
                    }
            }
        })
        db?.observe(.childChanged, with: { (dataSnapshot) in
            guard let value =  dataSnapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                if user.status {
                    self.changeUserList(user)
                    self.userList.append(user)
                }else {
                    self.changeUserList(user)
                }
            } catch let error {
                print(error)
            }
        })
    }

    func changeUserList(_ user:User)  {
        if userList.count == 0 {return}
        self.userList.removeAll { (userObj) -> Bool in
           return userObj.id == user.id
        }
    }

}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    
}
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UserCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if let url = URL(string: userList[indexPath.row].image) {
            cell.profileImageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reciver = userList[indexPath.row]
        if (Helper.currentUser?.id == reciver.id) {return}
        let vc = (storyboard?.instantiateViewController(withIdentifier: "ChatViewController"))
            as! ChatViewController
        vc.recvier = reciver
        show(vc, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80 )
    }
    
    func showLogin()  {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))
        as! SignInViewController
        present(vc, animated: true, completion: nil)
    }
}
