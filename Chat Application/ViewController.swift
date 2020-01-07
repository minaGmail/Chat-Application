//
//  ViewController.swift
//  Chat Application
//
//  Created by Mina Gamil  on 12/31/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let refrence = Database.database().reference()       // Test The Database
//        let rooms = refrence.child("roomTest")
//        rooms.setValue("welcome!!")
   }
    @objc func slideToSignIn (_ sender:UIButton){
      let indexpath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true
        )
    }
    @objc func slideToSignUp (_ sender:UIButton){
      let indexpath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true
        )
    }
    @objc func didPressSignUp (_ sender:UIButton){       // Sign up Function
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath)as!FormCell
        guard let emailAddress = cell.emailTextField.text , let password = cell.passwordTextField.text   else {return}
        if (emailAddress.isEmpty == true || password.isEmpty == true){
            self.displayErrorMsg(errorText: "Please Fill The Empty Field")
        } else {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in //Authentication
            if error == nil {
                let refrence = Database.database().reference()
                guard let userID = result?.user.uid, let userName = cell.userNameTextField.text else {return}
                let users = refrence.child("UserName").child(userID) // link userName with userID
                let dataArray:[String:Any] = ["username":userName]
                users.setValue(dataArray)
                self.dismiss(animated: true, completion: nil)

            }
        }
      }
    }
    @objc func didPressSignIn (_ sender:UIButton){       // Sign in Function
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath)as!FormCell
        guard let emailAddress = cell.emailTextField.text , let password = cell.passwordTextField.text   else {return}
        if (emailAddress.isEmpty == true || password.isEmpty == true){
        self.displayErrorMsg(errorText: "Please Fill The Empty Field")
        } else {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
                print (result)
            } else {
                self.displayErrorMsg(errorText: "Please Check UserName and Password")
            }
        }
      }
    }
    func displayErrorMsg (errorText : String){       // Display Error Message
        let alert = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let dismissButton = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
    }

}
extension ViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formCell", for: indexPath)as!FormCell
        if indexPath.row == 0 {                      // sign in form
            cell.userNameContainer .isHidden = true
            cell.actionButton.setTitle("Sign In", for: .normal)
            cell.slideButton.setTitle("Sign Up 👉", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignIn), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignIn), for: .touchUpInside)
        }
        else if indexPath.row == 1 {                // sign up form
            cell.userNameContainer .isHidden = false
            cell.actionButton.setTitle("Sign up", for: .normal)
            cell.slideButton.setTitle("Sign In 👈", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignUp(_:)), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didPressSignUp), for: .touchUpInside)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }

}
