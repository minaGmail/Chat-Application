//
//  ChatRoomsViewController.swift
//  Chat Application
//
//  Created by Mina Gamil  on 1/2/20.
//  Copyright © 2020 Mina Gamil. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsViewController: UIViewController {
    
    var roomsArray:[Rooms] = []
    @IBOutlet weak var chatRoomNameTextField: UITextField!
    @IBOutlet weak var roomsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        observationNewRoom()
}
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            self.backToSigninScreen()
        }
}
    
    func observationNewRoom(){       // observe the new chat room has created and add it to table View
        let databaseRef = Database.database().reference()
        databaseRef.child("RoomS").observe(.childAdded) { (newRoom) in
            if let dataArray = newRoom.value as? [String:Any]{
            if let roomName = dataArray["RoomName"] as? String {
                let room = Rooms.init(roomId: newRoom.key, roomName: roomName)
                self.roomsArray.append(room)
                self.roomsTableView.reloadData()
            }
        }
    }
}

    
    @IBAction func didPressLogout(_ sender: UIBarButtonItem) {
        try!Auth.auth().signOut()
        self.backToSigninScreen()
    }
    
    
    @IBAction func didPressCreateRoom(_ sender: UIButton) {
        guard let roomName = chatRoomNameTextField.text , roomName.isEmpty == false else {return}
        let dataBaseRef = Database.database().reference()
        let rooms = dataBaseRef.child("RoomS").childByAutoId()
        let dataArray:[String:Any] = ["RoomName":roomName]
        rooms.setValue(dataArray) { (error, DatabaseReference) in
            if error == nil {
                self.chatRoomNameTextField.text = ""
            }
        }
        
    }
    
    func backToSigninScreen (){
        let signinScreen = self.storyboard?.instantiateViewController(identifier: "sign in screen")as!ViewController
        self.present(signinScreen, animated: true, completion: nil)
    }
    
}

extension ChatRoomsViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        roomsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomNamelCell")!
        cell.textLabel?.text = roomsArray[indexPath.row].roomName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoom = roomsArray[indexPath.row]
        let chatWindow = self.storyboard?.instantiateViewController(withIdentifier: "chat window")as!ChatWindowViewController
        chatWindow.room = selectedRoom
        navigationController?.pushViewController(chatWindow, animated: true)
    }
    
}
