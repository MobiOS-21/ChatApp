//
//  ConversationsTableCell.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 04.10.2021.
//

import UIKit

final class ConversationsTableCell: UITableViewCell {
    static let reuseIdentifire = "ConversationsTableCell"
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    func configureCell(with model: ConversationsCellConfiguration) {
        userNameLabel.text = model.name
        if let date = model.date {
            dateLabel.text = Calendar.current.isDateInToday(date) ? date.toString(format: "HH:mm") : date.toString(format: "dd MMM")
        } else {
            dateLabel.text = nil
        }
        if model.message == nil {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "Futura", size: 14)
        } else {
            lastMessageLabel.font = .systemFont(ofSize: 13)
            lastMessageLabel.text = model.message
        }
        contentView.backgroundColor = model.online ? UIColor(named: "userOnlineColor") : .white
        if model.hasUnreadMessages {
            lastMessageLabel.font = .boldSystemFont(ofSize: 13)
        }
    }

    override func prepareForReuse() {
        userNameLabel.text = nil
        dateLabel.text = nil
        lastMessageLabel.text = nil
        lastMessageLabel.font = .systemFont(ofSize: 13)
        lastMessageLabel.textColor = UIColor(named: "secondaryLabelColor")
    }
}
