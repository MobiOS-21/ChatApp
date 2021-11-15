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
    
    func configureCell(with model: DBChannel) {
        userNameLabel.text = model.name
        if let date = model.lastActivity {
            dateLabel.text = Calendar.current.isDateInToday(date) ? date.toString(format: "HH:mm") : date.toString(format: "dd MMM")
        } else {
            dateLabel.text = nil
        }
        if model.lastMessage == nil {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "Kefa", size: 14)
        } else {
            lastMessageLabel.font = .systemFont(ofSize: 13)
            lastMessageLabel.text = model.lastMessage
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        dateLabel.text = nil
        lastMessageLabel.text = nil
        lastMessageLabel.font = .systemFont(ofSize: 13)
        lastMessageLabel.textColor = UIColor(named: "secondaryLabelColor")
    }
}
