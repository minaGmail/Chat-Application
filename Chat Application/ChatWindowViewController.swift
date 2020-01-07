//
//  ChatWindowViewController.swift
//  Chat Application
//
//  Created by Mina Gamil  on 1/4/20.
//  Copyright © 2020 Mina Gamil. All rights reserved.
//

import UIKit
import Firebase

class ChatWindowViewController: UIViewController {
    
    var chatMessages:[Messages] = []
    var room:Rooms!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observeMessage()
    }
    
    func observeMessage (){
        guard let roomId = self.room.roomId else {return}
        let databaseRef = Database.database().reference()
        databaseRef.child("Rooms").child(roomId).child("messages").observe(.childAdded) { (snapShot) in
            if let dataArray = snapShot.value as? [String:Any] {
                guard let senderName = dataArray["senderName"] as? String, let messageText = dataArray["text"] as?String , let userId = dataArray["senderId"]as?String   else {return}
                let message = Messages.init(messageKey:snapShot.key, senderName: senderName, messageText: messageText, userId: userId)
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
            }
        }
    }
    
              // how to get username with user ID
    func getUserNameWithID (id:String , completion:@escaping(_ userName:String?)-> Void){
        let databaseRef = Database.database().reference()
                    let user = databaseRef.child("UserName").child(id)
                    user.child("username").observeSingleEvent(of: .value) { (snapShot) in
                        if let username =  snapShot.value as?String{
                            completion(username)
                        }
                        else {completion(nil)}
        }
    }
                  //  sending messages
    func sendMessage (text:String , completion:@escaping(_ isSuccess:Bool) -> () ){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference()
        getUserNameWithID(id: userID) { (userName) in
                          if let username = userName  {
                  // print ("user name is \(username)")
                   if let roomid = self.room.roomId , let userId = Auth.auth().currentUser?.uid{
                    let dataArray:[String:Any] = ["senderName":username , "text":text , "senderId":userId]
                   let room = databaseRef.child("Rooms").child(roomid)
                       room.child("messages").childByAutoId().setValue(dataArray) { (error, ref) in
                           if error == nil {
                              completion(true)
                             self.messageTextField.text = ""
                              //print("data added successfully")
                           } else {
                              completion(false)
                          }
                       }
                   }
               }
        }
   
           
    }

    @IBAction func sendButton(_ sender: UIButton) {
        guard let chatText = messageTextField.text , chatText.isEmpty == false  else {return}
        sendMessage(text: chatText) { (isSuccess) in
            if isSuccess == true {
                print ("data sent successfully")
            }
        }
   }
 
}

extension ChatWindowViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chat cell")as!ChatCell
        cell.userNameLabel.text = chatMessages[indexPath.row].senderName
        cell.chatTextView.text = chatMessages[indexPath.row].messageText
        let message = Messages()
        if message.userId == Auth.auth().currentUser?.uid{
            cell.setMessageType(type: .outgoing) } else {
                cell.setMessageType(type: .incoming)
            }
        return cell
        }
        
    }


