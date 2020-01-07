//
//  ChatCell.swift
//  Chat Application
//
//  Created by Mina Gamil  on 1/5/20.
//  Copyright © 2020 Mina Gamil. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    enum messageType {
        case incoming
        case outgoing
    }
    @IBOutlet weak var chatTextView: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var chatTextContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chatTextContainer.layer.cornerRadius = 5
        chatTextContainer.layer.shadowColor = UIColor.black.cgColor
        chatTextContainer.layer.shadowRadius = 3
        chatTextContainer.layer.shadowOpacity = 0.8
    }
    
    func setMessageType (type:messageType){
        if type == .incoming {
            chatStackView.alignment = .leading
            chatTextContainer.backgroundColor = #colorLiteral(red: 0.9174832702, green: 0.8117514253, blue: 0.2635025382, alpha: 1)
        }
        else if type == .outgoing {
            chatStackView.alignment = .trailing
            chatTextContainer.backgroundColor = #colorLiteral(red: 0.9703056007, green: 0.8916502289, blue: 0.601375214, alpha: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
